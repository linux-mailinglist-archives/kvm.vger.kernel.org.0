Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BECD67337ED
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 20:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242470AbjFPSLx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 14:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjFPSLw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 14:11:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28A83589
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 11:11:50 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35GCi5T8026547;
        Fri, 16 Jun 2023 18:11:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=pH3otvl11JNj1TuptcdzxizNGXqkDBF53XlCNt1H2S8=;
 b=o+Q8cz09+y5Uut2i3o/r7ug8EgSUG+0iJ1lUnZ6zLpBmNqke6JruN0fnqsNFOZunCcBP
 f+98GoB0PIr6zyJMlj7JkI4qAtv6bceT9EhhlrtqvFONq7R9TVmKF/hQSpNHKVcUg+n2
 GXT2ZYbll2Zk2W82QGtjBrdp6hC3q99JmZ58em076b7tf3FhtrjGjzv6KXZlSYp+CxJW
 aRjmEX9z1+f9e+p2q1xnzIHWGCNmBEjAwKKPR973MhMbSIyQaTW/A8kiI6UwMbDUBN/o
 Nvq7wrIjO8WNj8S1ZqoU8ZQOL88CC7C+TdhQKozIcz4QSBOENjNztY+iweqQeB4pYong bA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fy3msxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jun 2023 18:11:11 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35GHv4Uk038876;
        Fri, 16 Jun 2023 18:11:10 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm895y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jun 2023 18:11:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M829ILrvO7VzWz0VftabmMX6KH7LhoX1PK6p1UKWLO9hVY/w/Hmmd/yU5Vvx7+3SNszYkdMQ8Na5poPVXxHCdDvQIkGKlOUY+hqGnCcff2OOUpQ9Yr7xF+5VnCyObLVegTLy5l6gM+8OWlM8a7XmxUUAJgkcUaZ5XEn5yaPZ9VduKnyosybc1PtI3GJcQlIvWgnwzfKUKmGtaJpMwE29NlcUr0diIrfxLHgG1l6dSCPNWzf7H6OpCtq9jxgT82GUehnxOX0hdrxGhPWfmfo3sa+e6AtGthIOK++ID66u+dZDndNB35BWq3v2iJ21F6nILTZsb6RWY9e2LcsHw5Vn8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pH3otvl11JNj1TuptcdzxizNGXqkDBF53XlCNt1H2S8=;
 b=Yu6sVSnYY+2K/q0ewgEJN35kxex7Q7d1CkNog0CLnRJkym0SzuY2qr5YcrqIn6PntwNP9ocSk6nyBg5FAE3QEhK88YqM/LbPE2IHzCyCuouIzNevXYQInJ9na9BdiP4zJVpu9DaZIfo9uxDoApJRTGY2uU/yYhEdWFfzxopRjb5RreD76AvBDQ3CxY241xmTCQsX52HvNGLbWcwliUrah/91ewouJL9ymAPZ/qdU43qEH63KmwMLf0kiyRzZSLmMsbDGm3TNwh/UMY7lG+xnAtGNYd0Z6lPP7IiUOWsCcB/ESM6CXyxpQfgNncgjyuGklR1Rw46dLOmTVHBtH9HQ1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pH3otvl11JNj1TuptcdzxizNGXqkDBF53XlCNt1H2S8=;
 b=uCmfF+oyD5xcsVQq7k2PimRq4p9Kh0qD91ttyiwwPibT41EJgIFMFO1zZn9irjxMAHkuMZcBcImcCNGvLRib6C5y4JNmWEpWCpVeaQPNUj2z1Kv3Hii0deD3xut+O3cRqRP5wnSNGFEM+5F3SAOATshzy8rRWS5Kl0AEnFEvdQo=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by IA0PR10MB7668.namprd10.prod.outlook.com (2603:10b6:208:492::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Fri, 16 Jun
 2023 18:11:07 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::f7ba:4a04:3f37:6d0f]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::f7ba:4a04:3f37:6d0f%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 18:11:07 +0000
Message-ID: <8ebd3086-3664-4c95-c779-245fa5e64c78@oracle.com>
Date:   Fri, 16 Jun 2023 19:11:00 +0100
Subject: Re: [PATCH RFCv2 21/24] iommu/arm-smmu-v3: Enable HTTU for stage1
 with io-pgtable mapping
Content-Language: en-US
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-22-joao.m.martins@oracle.com>
 <e16e35b399044e4f825a453e1b325e40@huawei.com>
 <e22772db-e432-c42f-181c-e7055aeed553@oracle.com>
 <f4656595f62a46e48edecd259bce950e@huawei.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <f4656595f62a46e48edecd259bce950e@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0125.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::30) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|IA0PR10MB7668:EE_
X-MS-Office365-Filtering-Correlation-Id: e21b5c18-df4a-4a0c-0be2-08db6e950e34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IqQXpLklqIaVm3aiCTazJjssDnsUVUSJSjaYxg25h++WrSivGacAjlAylweIv4QLrPOfvgvPjKEldItLRDQ+0LuE30SPSp+4KZropmxzzhpnf+OAdqlLmNOg2fmxjr0E2fEws+4E3bg1mBicjfBmdzIhqLEPxdGuOWCk3F0HcO+P8QYNiCQMWfHpAE0kOCIxLHIB0qyNW25vcmnR2L0yUhZ3S0W+SworogvVeFJnDL/u1/hQeu99A93R5B12dGZ0X+SptFrqrE3Ypyw+HkumLcWW9OO7+F5bxoCRieWDB3EGKXUcWg3IGT8AyhO7W1VRd5lmYL5cs7sSbyl1SjU9Ee0gtlmSdZARU1bu3h5LHHWlGR9wPmCHLS9AnBFxmU3BqB+wiMp/nplJCOhZxCY/D0nSYFWzmVdy7Fa3GzvOLxn9sv8/EyoWRJdnxPyvTMMVBxGmsGjMDprsTF+jhpkNPfEd1csWjfptjPqfIBHhmVCRl2N48OiH8QStYgvPK2I9zLRCI6lKvR2VDAuqUqiZOR9i23XeOzd7lcj790xVW3Mee15lhQieN+6XyX6kID/bpS20HCC4vYZormUp9bjZI9ZNJQkc2K69tiCKWOx/MQTaV0m46r7LT/YJ/3c9U+ra
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199021)(186003)(6506007)(26005)(6512007)(31686004)(2616005)(53546011)(83380400001)(41300700001)(7416002)(6666004)(2906002)(36756003)(54906003)(8676002)(8936002)(6486002)(4326008)(478600001)(5660300002)(6916009)(316002)(86362001)(66476007)(66556008)(66946007)(31696002)(38100700002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGx1Qy92YlRZNXBXVjFwZ0F5d3BUOG5rQnk4OW44TWQ3bUh6R3djU0Vka2ZI?=
 =?utf-8?B?N3VubW9zTHZqTUJVR0lpM3JEeEFlQ2dUMHUxWjFjSUF3bkNBdERmTE4vTFh0?=
 =?utf-8?B?amtUZlNRWVJiRkljQm9CQlk0bkp4QjZ0RForMHJIc29rRmplOFVIZTZKWitQ?=
 =?utf-8?B?alhiaUZEb0x1NFhPeVcwVnptbkpScC9sc0ptdXVIN1FlUTg2MVVydTdndW83?=
 =?utf-8?B?T2tmQ0N4MjQzTWJkZUZlNHh4RUsxdmR2Tmp2RHZRQ3RadzdpNW5ZRUNXQUxH?=
 =?utf-8?B?bEM0U2lGQk1GTUpMSXU0cnJodk5jQnFOYlEwNENlb1JqdFJQOXFLZlJDd0dw?=
 =?utf-8?B?dGVLUmpqZmJTL0dsWjdGTzlSNE9oVFE1TWxKQWhiR1JwY3V3YTdOZk15WFY1?=
 =?utf-8?B?cjgyU0M4T29HU1hjZUFEWnNCR1dxS3FsK1hyVnRueHRWemtpVHlURXVTV0FG?=
 =?utf-8?B?SXNzWWp3T1M5NCtTUHlLN3pTSHY4ZEN2aFppMWlGUE5JbHg5a2QrdEZ1eVFX?=
 =?utf-8?B?ZnA0WDRCcnhNcEdsS2xHemt4eTA2RTJpam5oMmRVcTlxQlY0RTJibjFjN3Fn?=
 =?utf-8?B?QlZLWWx4SlRRdTlEelNIVG9qdFFRVG1zVEU4REdvdW1kcU1QWmpUT3ZPOTU5?=
 =?utf-8?B?Z0hlaTJodkdaRjhyMVlLb20wMFlSQ0tKV3ZmaVNza0FqUWJ4SDh4YWxwVjBy?=
 =?utf-8?B?dVhSZnBHVzVzZXpTTFIvRkhqOEIyMGxTT2NwclNqRFUyOVVkRTFOZHo1QTVp?=
 =?utf-8?B?SU1LakV5c1FIUFRPejFyNUw1QjFrN3o0NEZKR1ZhaTdQeWpMbVk1cGdnVzI3?=
 =?utf-8?B?WXplR2F1V2ZvT2J2WWM1QlE3OWtwVkd4UmJkUjQvRGliaWpSMnMyUG5JV0xH?=
 =?utf-8?B?V09TUGtwdXVhR1RYanFXNVMxQ2lMMjRiMWh4Q0tNY2tXd2d0d1pvWG1QeU1p?=
 =?utf-8?B?SDRwcWZncDZoZ0lBRWg0U09WS092QnU5WUxrOGtHWWRWcEsyR1VXVHQxTEFG?=
 =?utf-8?B?QUU0VVN4MFFodEZybkJQQW9YVjFrOG1NUWdYbUxBa0lBMXhWS0cyeTJyNytq?=
 =?utf-8?B?TkM3NWRuTEJlS3RnRzArZGVZaHRpTm44NlRXaWxwZC9OeFNtcFI0WGxhUzBQ?=
 =?utf-8?B?RmcxTU5PQ24wQUZuNGlhUllEZmg4Ty9sMnZPdmVEYUxoY1ZmUHNoOXRnTmg0?=
 =?utf-8?B?WFZoTTdjcVpaYUd2Q1p5cms3MDJMVVMvallXOXhZdnQ5eUpHdnhzNy8wRXI5?=
 =?utf-8?B?M2tqbmc2YzdzUE9KRDZ6Wko5WERRemkyWUd0TlZjcjZCL0VDOGIvUlBqb2hh?=
 =?utf-8?B?TW56YmVXK0RqdDNmS2FsM1VYaUFCTktyNElOS1BhNkpBb2did3k2UFlZL0Nh?=
 =?utf-8?B?UDM2Zlk4a2tWSUxzbU9veHY3QTlvS0x2c2RPNEI0RlRqMWRiSDZSQ3lwWWFH?=
 =?utf-8?B?eERQZFBBaUZHNndFMlJCdnA4L0RSMmFCTE8ydmNZN3VySHZiNVBMVHVvNWsw?=
 =?utf-8?B?Q2tQQUV1K1VGZXN3UGRsQ2trR0J4R2hsVVZ3Y2xSczhsUjc4VDNaUEl2QVNQ?=
 =?utf-8?B?d1JhK1VtUzBDT0ZZR0FRMVlML1BkRDFGWG9zSmJtZENMLy9xQ21nbjVtNEw4?=
 =?utf-8?B?Rm5WRTBGc3JhZXV5Yk1GQlFhZTFmTCtPeVZOY2owMWNtRE10SC92UGx3MkdD?=
 =?utf-8?B?b09NUXJOZUZaaGNtbU03aEgvcWhDWDMyU3RYY3UrSnZYaHVEMXNmdG8rRGVI?=
 =?utf-8?B?Q3RjNERlM0J3c3R6NlllK2ZkdjFmZTllREplYitHY2szQXlhcFBPMVlLdlNa?=
 =?utf-8?B?T3RpajhNendqc1JKTEJNWXk1ZzcyeC82cjhYVFhvWXB0M0pIZVVIaTNVUUJT?=
 =?utf-8?B?K0lheWhhUWU1S1dRUURxa3ZJL3hlUkxCZElTSThQTldYMlV5ZXhNcDhtUG93?=
 =?utf-8?B?Y2ZzU0JrMzJacGFnVE5GMm94M3cwVkozWmpodUp4YStkbE1HNDc2aEJQcith?=
 =?utf-8?B?UTc2RjdDdWlpSVNFaG5pU2hDcmN3RjhpaWVRc1hjZ3pnS3BGRDZWVnhxMHJy?=
 =?utf-8?B?bWFWNUt3TWZrU3l2NXFDU29MR2RwUWdUOGcwb1h0bmppd3JEeURqZDY1aXUr?=
 =?utf-8?B?TkZaRDVHcVZRa3UxbExIQURTQ0tLR1JwZE1ZTW9LdVdpZFZDTHZ2QUEyNmth?=
 =?utf-8?B?YVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?amRPaUwzZGE0TG1xbXVWK0NPY1ZKdjZpZDkzWllZZXVEWFVhUXMybkJxYm9C?=
 =?utf-8?B?Wlg1MWRYcU01MDdLWEw3VTJOZGhjOTd5dWJ0ZFplVjFqTG9FcU1ZZWVMQUln?=
 =?utf-8?B?QmZidTZzeGZSaGJKbFU2NTQ4V1FraVNEb3Z5SnNzcVgyNGN6M2NNcU8rTU1l?=
 =?utf-8?B?ZVQySzZTVmNVQk1JejV1bnBNMEUzWVlMTi9OcFlVZ01WbzhEWWhLcnY5MDRU?=
 =?utf-8?B?YkgzbnUyWWVob0pJaHpNazlUb1d5YnhNMzJZQ0hzMlN4VWdGMG56cDNoQlcr?=
 =?utf-8?B?dEtDUnJVbXpMMm1jYXJQSnhjU0ltS2wyVmpnSGhmeVowMmduU01yQnF6Y214?=
 =?utf-8?B?dGFPM3BZK0dkeVdtTDVBUVFNTWJzZ1lhZGhVYXo2RTFaWDBjOWxSa2xDYy9G?=
 =?utf-8?B?bXplVHdmREtSNGxjOEdZMkdTMjZGRFFubzdBeEQzUHR5ckEyK3hhd3h4UnFn?=
 =?utf-8?B?d0FnRS9KWkx2VW5nalNOaWRQb3VJbW9mKzNySTdlajhiOTh0TExSazBVbk5u?=
 =?utf-8?B?KzNFcUozdGo5a2Uxbk1pc0RWS2JXOVRlckFCRldHb1p3bWxzakJZSmxoRjM3?=
 =?utf-8?B?djc1UndWYkpWeTQwMWhPTWNTaGMzRkF2enI3NUtNMHpCZjh6ZEd3ZUJ6aVRN?=
 =?utf-8?B?U01pQmlkRzFuWVlpOWNhR3g0aldva1M4NjRUYTNsR2c2WnBWdUhKcVZ1WVBy?=
 =?utf-8?B?ZUcrRUZsNUs5aU1RcjkzTU1VelB1V3ZMeEczUWdrS2dqSCs3cERJZlVMaEhC?=
 =?utf-8?B?c0tNWExuM0tkdXZqbGVrRkdwMktTdlBqSFVyMlZoZWhhSUpHY04zZ1pOeERp?=
 =?utf-8?B?bjNHMW83c0N2OWtQa1RaQTV6eEZ0WUFDSjRPRktOcnNmZnpkNGVkUk9HVWY5?=
 =?utf-8?B?MWlKc3BkaERKcFIwdEFFSUlQWU1kNGUyV2RMVGJrVFpOK3BTZUhDNWtoNkRI?=
 =?utf-8?B?djUwME45c3RERGdMRE11NVJrSEFSYVo5ZjkvSm5BTjNWUm9OTlBId2Z2WTFT?=
 =?utf-8?B?QzNwR3c4Q3VTTGdDV1B2RXdrUVRUVnJaRFJyblBLd2wrRVN5YzhyTThQTGt2?=
 =?utf-8?B?dVVaelJkcUU4QTIwR2QyMlJseUZ3dkVSWmkwQzB3eGFjRWdYdUtVQUNQWWsw?=
 =?utf-8?B?SGRNNzdoY3czanNZR1VCVWNCZ1lveUpzOE8xZHNycnBrUXNHK1UyMStaeXND?=
 =?utf-8?B?azdwY2h4OWxmU2lkZkhRbU9UaXF2RkNQZ29RZGRCZWhRZnVPcHIyczVlZDJ0?=
 =?utf-8?B?alAxZzQ4N3c0cTRYOUQ1QlZScytHTWdwVUFobnJrdWQrNk5STzRHSGJERExP?=
 =?utf-8?B?VGlXcVNFZkw1MUU3bTUyRE8zWm5KS0gyUXo1L0poSkRRTHlKcjY3dG45ZVFS?=
 =?utf-8?B?UGM0NkUrZm14Smt4UjJHKzR4N2hiaFZBWUp4akQxU01ueCswVitxeXZOWXE4?=
 =?utf-8?B?c1RRYkcwR0diZWhwTDVtczZoeEtTWUtzTnpyTk5BPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e21b5c18-df4a-4a0c-0be2-08db6e950e34
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 18:11:07.3937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lrGcc9AC5Px6x64q3L9hmb+45Xy0mm3eom2bN5pLQS4qwODQpV0meWKd9t/ripvI6eGc/35WTKW4DksjRsZpG2frpJnO287vRRRyxYrG/cs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7668
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-16_12,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306160164
X-Proofpoint-GUID: ykTuKMmFEIuGH1ZYYgv7r4waJvVXLR85
X-Proofpoint-ORIG-GUID: ykTuKMmFEIuGH1ZYYgv7r4waJvVXLR85
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16/06/2023 18:00, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: Joao Martins [mailto:joao.m.martins@oracle.com]
>> Sent: 22 May 2023 11:43
>> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
>> iommu@lists.linux.dev
>> Cc: Jason Gunthorpe <jgg@nvidia.com>; Kevin Tian <kevin.tian@intel.com>;
>> Lu Baolu <baolu.lu@linux.intel.com>; Yi Liu <yi.l.liu@intel.com>; Yi Y Sun
>> <yi.y.sun@intel.com>; Eric Auger <eric.auger@redhat.com>; Nicolin Chen
>> <nicolinc@nvidia.com>; Joerg Roedel <joro@8bytes.org>; Jean-Philippe
>> Brucker <jean-philippe@linaro.org>; Suravee Suthikulpanit
>> <suravee.suthikulpanit@amd.com>; Will Deacon <will@kernel.org>; Robin
>> Murphy <robin.murphy@arm.com>; Alex Williamson
>> <alex.williamson@redhat.com>; kvm@vger.kernel.org
>> Subject: Re: [PATCH RFCv2 21/24] iommu/arm-smmu-v3: Enable HTTU for
>> stage1 with io-pgtable mapping
> 
> [...]
> 
>>>> @@ -2226,6 +2233,9 @@ static int arm_smmu_domain_finalise(struct
>>>> iommu_domain *domain,
>>>>  		.iommu_dev	= smmu->dev,
>>>>  	};
>>>>
>>>> +	if (smmu->features & arm_smmu_dbm_capable(smmu))
>>>> +		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_HD;
> 
> Also, I think we should limit setting this to s1 only pgtbl_cfg.
> 
+1, makes sense.

> Thanks,
> Shameer
> 
>>>> +
>>>>  	pgtbl_ops = alloc_io_pgtable_ops(fmt, &pgtbl_cfg, smmu_domain);
>>>>  	if (!pgtbl_ops)
>>>>  		return -ENOMEM;
>>>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
>>>> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
>>>> index d82dd125446c..83d6f3a2554f 100644
>>>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
>>>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
>>>> @@ -288,6 +288,9 @@
>>>>  #define CTXDESC_CD_0_TCR_IPS		GENMASK_ULL(34, 32)
>>>>  #define CTXDESC_CD_0_TCR_TBI0		(1ULL << 38)
>>>>
>>>> +#define CTXDESC_CD_0_TCR_HA            (1UL << 43)
>>>> +#define CTXDESC_CD_0_TCR_HD            (1UL << 42)
>>>> +
>>>>  #define CTXDESC_CD_0_AA64		(1UL << 41)
>>>>  #define CTXDESC_CD_0_S			(1UL << 44)
>>>>  #define CTXDESC_CD_0_R			(1UL << 45)
>>>> diff --git a/drivers/iommu/io-pgtable-arm.c
>>>> b/drivers/iommu/io-pgtable-arm.c index 72dcdd468cf3..b2f470529459
>>>> 100644
>>>> --- a/drivers/iommu/io-pgtable-arm.c
>>>> +++ b/drivers/iommu/io-pgtable-arm.c
>>>> @@ -75,6 +75,7 @@
>>>>
>>>>  #define ARM_LPAE_PTE_NSTABLE		(((arm_lpae_iopte)1) << 63)
>>>>  #define ARM_LPAE_PTE_XN			(((arm_lpae_iopte)3) << 53)
>>>> +#define ARM_LPAE_PTE_DBM		(((arm_lpae_iopte)1) << 51)
>>>>  #define ARM_LPAE_PTE_AF			(((arm_lpae_iopte)1) << 10)
>>>>  #define ARM_LPAE_PTE_SH_NS		(((arm_lpae_iopte)0) << 8)
>>>>  #define ARM_LPAE_PTE_SH_OS		(((arm_lpae_iopte)2) << 8)
>>>> @@ -84,7 +85,7 @@
>>>>
>>>>  #define ARM_LPAE_PTE_ATTR_LO_MASK	(((arm_lpae_iopte)0x3ff) <<
>> 2)
>>>>  /* Ignore the contiguous bit for block splitting */
>>>> -#define ARM_LPAE_PTE_ATTR_HI_MASK	(((arm_lpae_iopte)6) << 52)
>>>> +#define ARM_LPAE_PTE_ATTR_HI_MASK	(((arm_lpae_iopte)13) <<
>> 51)
>>>>  #define ARM_LPAE_PTE_ATTR_MASK
>> 	(ARM_LPAE_PTE_ATTR_LO_MASK
>>>> |	\
>>>>  					 ARM_LPAE_PTE_ATTR_HI_MASK)
>>>>  /* Software bit for solving coherency races */ @@ -93,6 +94,9 @@
>>>>  /* Stage-1 PTE */
>>>>  #define ARM_LPAE_PTE_AP_UNPRIV		(((arm_lpae_iopte)1) << 6)
>>>>  #define ARM_LPAE_PTE_AP_RDONLY		(((arm_lpae_iopte)2) << 6)
>>>> +#define ARM_LPAE_PTE_AP_RDONLY_BIT	7
>>>> +#define ARM_LPAE_PTE_AP_WRITABLE
>> 	(ARM_LPAE_PTE_AP_RDONLY | \
>>>> +					 ARM_LPAE_PTE_DBM)
>>>>  #define ARM_LPAE_PTE_ATTRINDX_SHIFT	2
>>>>  #define ARM_LPAE_PTE_nG			(((arm_lpae_iopte)1) << 11)
>>>>
>>>> @@ -407,6 +411,8 @@ static arm_lpae_iopte
>> arm_lpae_prot_to_pte(struct
>>>> arm_lpae_io_pgtable *data,
>>>>  		pte = ARM_LPAE_PTE_nG;
>>>>  		if (!(prot & IOMMU_WRITE) && (prot & IOMMU_READ))
>>>>  			pte |= ARM_LPAE_PTE_AP_RDONLY;
>>>> +		else if (data->iop.cfg.quirks & IO_PGTABLE_QUIRK_ARM_HD)
>>>> +			pte |= ARM_LPAE_PTE_AP_WRITABLE;
>>>>  		if (!(prot & IOMMU_PRIV))
>>>>  			pte |= ARM_LPAE_PTE_AP_UNPRIV;
>>>>  	} else {
>>>> @@ -804,7 +810,8 @@ arm_64_lpae_alloc_pgtable_s1(struct
>>>> io_pgtable_cfg *cfg, void *cookie)
>>>>
>>>>  	if (cfg->quirks & ~(IO_PGTABLE_QUIRK_ARM_NS |
>>>>  			    IO_PGTABLE_QUIRK_ARM_TTBR1 |
>>>> -			    IO_PGTABLE_QUIRK_ARM_OUTER_WBWA))
>>>> +			    IO_PGTABLE_QUIRK_ARM_OUTER_WBWA |
>>>> +			    IO_PGTABLE_QUIRK_ARM_HD))
>>>>  		return NULL;
>>>>
>>>>  	data = arm_lpae_alloc_pgtable(cfg); diff --git
>>>> a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h index
>>>> 25142a0e2fc2..9a996ba7856d 100644
>>>> --- a/include/linux/io-pgtable.h
>>>> +++ b/include/linux/io-pgtable.h
>>>> @@ -85,6 +85,8 @@ struct io_pgtable_cfg {
>>>>  	 *
>>>>  	 * IO_PGTABLE_QUIRK_ARM_OUTER_WBWA: Override the
>> outer-cacheability
>>>>  	 *	attributes set in the TCR for a non-coherent page-table walker.
>>>> +	 *
>>>> +	 * IO_PGTABLE_QUIRK_ARM_HD: Enables dirty tracking.
>>>>  	 */
>>>>  	#define IO_PGTABLE_QUIRK_ARM_NS			BIT(0)
>>>>  	#define IO_PGTABLE_QUIRK_NO_PERMS		BIT(1)
>>>> @@ -92,6 +94,8 @@ struct io_pgtable_cfg {
>>>>  	#define IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT	BIT(4)
>>>>  	#define IO_PGTABLE_QUIRK_ARM_TTBR1		BIT(5)
>>>>  	#define IO_PGTABLE_QUIRK_ARM_OUTER_WBWA		BIT(6)
>>>> +	#define IO_PGTABLE_QUIRK_ARM_HD			BIT(7)
>>>> +
>>>>  	unsigned long			quirks;
>>>>  	unsigned long			pgsize_bitmap;
>>>>  	unsigned int			ias;
>>>> --
>>>> 2.17.2
>>>
