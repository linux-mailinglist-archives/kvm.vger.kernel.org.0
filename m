Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64917691E56
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 12:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbjBJLcy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 06:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbjBJLcn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 06:32:43 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE76071F03;
        Fri, 10 Feb 2023 03:32:42 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AAmxPr007710;
        Fri, 10 Feb 2023 11:32:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=lZHokvJS1SnxZsagDdpGqy62Znf0vvAJEzdhzzLbdGo=;
 b=tXylBLrcAYQWFfZzJG9/HloLONXhKe0VF8Q7U8xvNyX3yOawdnordjN3F5fZDmO8C8Zl
 oUa+VYLS8LtoOVG8Xvwpu+FKlBzPTj96w23zdO+cYXIMiYJdwyotMBXGKprvN3dYHt36
 xR5+Vvmv1KjpwlZBzeZ0zf5GBIFy82nGpz9NjJ4n7qImMPmXBx2FgJb7eHELnHhyGGe5
 /ZIB9VGvk/+axcErBrKJeEzS+nN0lZWjIfmrus+eaaka4SNcjdU1yjMX7d2JdFZE86Vi
 26wSq96NBxaA6nmdcvR3eaCYta8p9MviUk5BPyleUNzgFCC8aDaTHSgFDKANgTGz8mku Xw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nheyu54gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 11:32:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31A9KUSE002706;
        Fri, 10 Feb 2023 11:32:04 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtgqa30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 11:32:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9KwXAUNUd+5ynmIDKCAIIaekMflnwDug5hyfjrR1pJsggxibtNgy/UskN0aVj4hh5mSFLFd+jzsB/of++htdBEyt9OYhsJNGwPSzv9cR1iZveyYFWC1vIO1OfecsuOHdab0OL6waMLRGHK9arJMlsty6PtZLV4+ku3VLrruuLhelznPjTSxES1bTZw54o7B4rAeKVtsUhcf6vHSlxB1yAc07Ix+MBM9bzfYYjAq7q6yg/swYLLn/tL/sMnNV8BE2Wer7kGATyuLM73SyX7RFB1GsNFZM6kG7zH2lxH20BvZ7qJwsLDbQdhCgla7CMLjKwdCx4KYfU8FyluoTYaf5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lZHokvJS1SnxZsagDdpGqy62Znf0vvAJEzdhzzLbdGo=;
 b=Q1lFNmZwIrbktfasDzql/Z6FXHPz+bTx8nMmscDgeKdQrzNayGPtRncXYVEUUep1S8ANXraztqGoxFuEi8NG6Wk/N05OdUMeLSelxZQPnBf7XufJ72Uqtg5ZBqL8I0EQIVK/ngRRc9S6doPfXJa62rNm6uAbRnJ8fjQ6/LhWMRFJ4SKiZQSyAJOetPN+czsp/si1rM3aINqj8yiZ2kwmZJ78Gg7kccJmPXh5OnOaJp+5weuOgEPIWbOPynWn9vW8dZW/oM+Ehp0kIr1P9U81t/6Ujsz28q/lYFyRCp0pG0M1EqTSsZT9XKLSgAmFIO6LzuombTTGe1A2TJvn3EmgUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZHokvJS1SnxZsagDdpGqy62Znf0vvAJEzdhzzLbdGo=;
 b=hZZD6V83nMu7AtsZdewZrioOWqGnbs8lTnakqgRKEd6VKlPg2Mvlh7RQYcN1aKxV2HiN+rojp5ismfJAJFJdKm2mZKCUp2/2C57i9B1K+Ex/OMj3fWVOGEKGWujlPxVUAN6cFL1vdgj/JVZ2CASje4iviYBZo2n2Qx+Pf64c+hU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CY8PR10MB6513.namprd10.prod.outlook.com (2603:10b6:930:5f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 11:32:02 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::9b30:898b:e552:8823]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::9b30:898b:e552:8823%3]) with mapi id 15.20.6111.007; Fri, 10 Feb 2023
 11:32:02 +0000
Message-ID: <d6a0fee5-9936-6d54-31e1-91241b59d895@oracle.com>
Date:   Fri, 10 Feb 2023 11:31:54 +0000
Subject: Re: [PATCH v2 12/14] vfio: Add cdev for vfio_device
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, alex.williamson@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, jgg@nvidia.com, kevin.tian@intel.com
References: <20230206090532.95598-1-yi.l.liu@intel.com>
 <20230206090532.95598-13-yi.l.liu@intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20230206090532.95598-13-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P123CA0001.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::10) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CY8PR10MB6513:EE_
X-MS-Office365-Filtering-Correlation-Id: 08df3d07-92b2-47b2-50b4-08db0b5a6d97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yV5SYf5r/df7i/rmw6bTSk9X8Us+hm6siGfo9r6fUzCw2PNUCyGQdeLYSgqNy7W726wmZzMi++9OLm+dtGsmOVoY1TsEY2SRli8eoM5vGHU8/J9rIofavL8AlD9H8sGUbNzMAlg0hAIwLJVAspyHjGm3Ou7dY9xCiBqfXKDAV54csqBGCsF35lXSfK6bjFCQg9XlD1DVfAUiaHeOHNG4pCEoHAfwQLKJLmyCndr4qrBpi3g8Ae3CSBDWvWw5zOm/dwzbBjMkXLRb6vxGD0uAWy1jq6aHV15wuloZEyflTZjq+iWoa6QT+n711fDpbrZdZGH56aSJ2T3kBAQ0QU0Y65vvjy/i2NPYjk1ebx6Q6pW/VAJT/H6rQRBhLwu46xX4JQfW+XnN37fjtt8qnVT8WtNGFsSjKazRo+geCvHFYAHtK/KsQE2ZNgSxSnxUrV0uDczAQATVz+3j0/7Sj78XEHc/nLQoTZSOk+fnRI0lV7SGkJWj3P/ZNI8WaQERf1qhYhSApiRiHkPSNnXqw5JZvbTZrzIyaf3+FDarvepiPU0EdKmOhqsH35M6K+P2b/gPzTrrZRuu9+R6ga/KYLC/PRdFMCBJoWD5lKEhUn5msLs+VqGsDnaaZ/s5eU/N0na+UIcPBEBonchvTvD14DANA6e+xVyzTdxSzX+tWnuA0cANTIa8fUxoEWcQ0RQo+PZAY3W1F4JAMEbEU76C4faZcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199018)(31686004)(6666004)(6486002)(2906002)(36756003)(41300700001)(8936002)(316002)(38100700002)(31696002)(2616005)(86362001)(53546011)(478600001)(6512007)(186003)(7416002)(5660300002)(8676002)(6916009)(26005)(83380400001)(6506007)(4326008)(66946007)(66476007)(66556008)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T00xTlJSb3VhRXowNkVrczUyTFFpYjYyNnZERU5lSElrejlva0ZVekJvT0hQ?=
 =?utf-8?B?Nks2TlVSRU93Y3BtbytuTnBLdkZ1VjNrZXVFbzJHSjhoLytXNS9uMXVQcFdK?=
 =?utf-8?B?ODN6eWUvUWlGNUN6VVNwbnBlUVgzUTdrdlkvMkY5MFNQL3l2QXVRN0JTNkw5?=
 =?utf-8?B?Y1NOUHN6Mzl3SnIxZmZ3dFFENmxQbW4rOVhZU0w5WG94ajF5VVBTRXRvQjdZ?=
 =?utf-8?B?UnREUmp5dXV4NlhHdXJ0bld4MThJaElYUmYyUmxvNUtKM0toWjZtMk1CQWdy?=
 =?utf-8?B?bG83bk1VTTNRSWVPbVgvZ3ZCamw4dmtDdjYyb3V2aVZZdmU2ZmZ3MzZaaS9Y?=
 =?utf-8?B?b0prbzBHVHA0YWtLRStRcjJ0MnlUaGtFRlVXbG1WS1hlcWdHeVhIbWNzaDBs?=
 =?utf-8?B?T1gvS2VyYjl6b0VPcVdhV2dKL0dhdE1CNHo4eWZvN1Z6K2dLNTBmREVLOGlm?=
 =?utf-8?B?eTFjSU9zTFY1dmNRaGZYUWs5LzV1T3FDWE5UWnB5RWVJb1Z3RHY1Mlhvc3Fq?=
 =?utf-8?B?ZGJpN3dXdjJxVUM1N01hK3c5S2Z3cXBCN0FRUUgrVW9uQ0pDQ1BwYnFPVktS?=
 =?utf-8?B?bDgwM3VqaXoxM044U3YrcFM4OE5FbDlaQTkxRzdqRHJSWUl3NkNhMFJpbEpa?=
 =?utf-8?B?V1hJeHh5WjErMFEyZDBGZXZCYzdVVmZtN21GVUV6RVZYa1lkdmNBTnQzSEdi?=
 =?utf-8?B?KytRczFNd3pCQ3kxSmI3aWx0MEVPZTBJTjcyclFZWmYxakYwSXBjM3F1WUM2?=
 =?utf-8?B?ZTBVeGc2ZWVXM0JMVnN4c2p1NFdwU2tsT3drR0hCUGoydytSbDV1Z1E5eDkv?=
 =?utf-8?B?R09GcnBMbmZiQjVYR3U2L2xKUm5SN0toeGRhaGlCOHZFeHh3UFNLMFpUZmZG?=
 =?utf-8?B?d1QvTmZkTmVOekRTdURCcDFxNFJTeStOaHhzMSswT2xoTjk4ZU84RGd0Tis0?=
 =?utf-8?B?U2lBM0FzWXJDdjdvbTV6aEtvOTNBaXJ4YndmK1pUY0NlNTVpMDJ1MEFwSENS?=
 =?utf-8?B?aE9wbmpHblNBSzZDaHlJWGYrUUJPSE52ZmwxaFQ4R0tGSThXZktkNHVQOXBZ?=
 =?utf-8?B?NGh0a0xrd2M3clZ5YVozS1NnN2pCMkwzaVB4QUlqbFpuM3BuT3lDUSs0WUlC?=
 =?utf-8?B?MkZWRC9UUWFtbG15dEJVV0RmUGloMmFCYmJqOWVDbjVUR3d4eFdaemV1WWYv?=
 =?utf-8?B?TDkwY1BZdTlTb3RLZk5zaVlZbXIxSkpERFcxUmFXVVl2ZWZqNWU0WnhIVEZU?=
 =?utf-8?B?TTlHakdqbkdzZlJhdGdHVk0yY0RUdHR5V3MwU0pXMElNNThKSmJJekV6QUpr?=
 =?utf-8?B?dGw0VzBicjBadDBXbTVUckVMaUJSSytTV2NSbkZoalFISHgzNmtOT3JDaGJp?=
 =?utf-8?B?dEozdGZlL2s1d2F3Ny9nWFNvRFlwTjlUckt6d1VuUkNIaHM2VVYwMEtCRFdS?=
 =?utf-8?B?RmJvb1IxZVEzVGlMekxYVFdtVG55SlF6alkxS2VlWDlNVXQ4NnVNMVdCQ1pF?=
 =?utf-8?B?TVBpbzNmYWxXSmlKN2xpYlFJRjh0R3o3Rlk2L1IwN1dHdzY2NU1UQ2ZMSDRm?=
 =?utf-8?B?M1gzd1R2N2hNQzIvRkN1eWo0Rm1pU2dZSzlSUDM4VCt5b2puMGoyRGx5R09F?=
 =?utf-8?B?cXlwU2VtVGR2My9qVDk3dHlFUVUzM29vdnlVdTQ5blZjQ0duZGJOeTRtaFZS?=
 =?utf-8?B?Um5RbHdNNjRnMmV6Q2pDT1JCRlhCRnpjclI0bDJSdTFDR0Nhb2ZUT2pZY08z?=
 =?utf-8?B?UDdyeTdDT2xzRG41elUyQ3MyOHp1MzgrUnJ0a0xwMlIvRkN5T3Q3b0gvOERN?=
 =?utf-8?B?MzNBTGpxUmEwYjFaNmVjNjRyTzJqNS9SWHllUk82YUJWbEpBRHI3d3B0U1pl?=
 =?utf-8?B?Vm9sSlJKckNGRHJPMVRzMWtmZVE5OFYwSFVEalZGK2l2TXNzWlhBWDdXbnRi?=
 =?utf-8?B?WmMwNmVYN3BZSXdFOVp4Yy85S0NIZnVnMjVTUWZCeURIeHF4QXo4bmFsQUpZ?=
 =?utf-8?B?WkNnSks4YlVKc2tYYTVJOGYrWjRBeWw3RUtNcVphb295T25XSFJBWk5IUEIz?=
 =?utf-8?B?ZVhzSzZ3eG5tZndkUm05SkoyNmR5ekxEVDVaWWZBeVU3MU9odURjb0k5QmNV?=
 =?utf-8?B?eHpYUStmVU90VU5yc3ZXNGNWbWhHY3cwRWFETlRzMkpWQ0ZwaUlDdm0rektO?=
 =?utf-8?B?M3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?QmowT3dxbUhuUVlUQWNXMDhPQ2lLc2JGWnZTU2c2TlNZbDhubEx0SmpzeU9P?=
 =?utf-8?B?cHVkRVZ0VVNRR2E4TWgrVllCaUxzVUcwL0xNOVJxZ1NLdkJvMlZ2R0pPM0Z3?=
 =?utf-8?B?UmdMTDAyZWlIbE1JQU1uUnA3cmh6U0Q5SjZoZ3JWRFhZdVVQbjNKVFJZejgw?=
 =?utf-8?B?ZGhGdldhRFZSdU9EMnE4VXRNZzBreThmMGxVZW1EOUlQd0h6NWtvelhFazMv?=
 =?utf-8?B?NUY1M3R3QW4yc2wzdnpGRllEa2hMSTR2emZ0SWJENjE2QWVWbEk5OVFUOERl?=
 =?utf-8?B?MXorQjFwWnJpVW9oSlIyL2NOLzRhVU5NUmtOcnFFSUM1NTdsZHB3WnMxSWow?=
 =?utf-8?B?U2p0THcrR0ZZTXEwd0pCVEFDWE5iV1VBZVZEZkw0NEY5ZDl5M1JIU3ZOUWdr?=
 =?utf-8?B?eWZITjNCSjNqSmczQUYxMGJCWWNyRFhIek5QaDhKZ1pJMTcySnlFaTBaa0M3?=
 =?utf-8?B?WFF0L1NkZnVyNGh5eVJCd0VHR2k5b1diVDZuQkZvWWVOK3pNNk52ZjBtcUJZ?=
 =?utf-8?B?WUpBSHNYbFJGajB5RUE3MUhBUHg3bXM2b1J0UzNVN2NSaEZEWTFPSWlCcXBI?=
 =?utf-8?B?QmpvckhhRzdEZWhWdUt5U09EK3RuSkgwYk90dHNlOG9PQS85RlhzNWNoMk84?=
 =?utf-8?B?VEZHVENWODNyZmdmRW51V2JrMlU1eG9WV282dFZtZjBtVEJ3cnhrbE5sU2pC?=
 =?utf-8?B?WDBnR1l5eFF3NmdpcERYWXB5SEVWbDl4TGNseVRPbUpXanBKa3ZiRkg0V3dr?=
 =?utf-8?B?VWpydVlEdEp4L3dOMkNLbGEyMzJ4aUlmcFhDSlVoOHc0ZDlta3QyZ0QvcmFQ?=
 =?utf-8?B?N2tzRzhVTWJPTiswRzREd081Z0N6L29VV09wdm56MGpSdUlad0ZqbUVCU0pi?=
 =?utf-8?B?ckJsaHVweVdnZ3lGRXlxZDAzZEJueENuWDYxRllPZ05yMUlsbEM3ZHRSWC9x?=
 =?utf-8?B?SEhpWTNCTUxuYlN3SEc0VUFEdHRLdGdlNUZ6S3dQbi85ckx6S3NXU1JKb1BM?=
 =?utf-8?B?ZkRyRVdrcEZ6OXlqVmQ5dVlYUzhmd3ZzelFTdXI4SENSWVFYSEtrRlFzSFVS?=
 =?utf-8?B?UTdEOWFtNDdIK3Z1T2ozY1RyNlVJVTBPOVcxeG1aUTJoNGMwZHlQRVZkYkZh?=
 =?utf-8?B?VDNmdVlWbkk0VVNrL3pwOUdkelhNMHZzYkYrSlk5QUxBdU5RSndjeXpsWE1o?=
 =?utf-8?B?ZGtDQlpoeE9pZDZMc3N2bWNudXIwemUyYTI0ZWhPUEk2RGtBYktxblgxbkZ4?=
 =?utf-8?B?dkZsaVJmd1dLc0JiVlNZc1UrWlZ1UTNLeEVyUFdMRDR6Q1ZkR2lra2lsOHNa?=
 =?utf-8?B?TjBJVnRIZ1VUNmIxTHpQL3NtbVhOdVRVSUdOSEEraWxGVHY2cVRnS0N3WUZS?=
 =?utf-8?Q?gY3KYpn9uHyyaaAozDhG9RKfN0eYwW9M=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08df3d07-92b2-47b2-50b4-08db0b5a6d97
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 11:32:01.9933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mktLb6jlUIErVJMsptQ8DvGSJpntcJd08tooHnklxCnbP/jReM0117NpWv/Nbq0rMDwt1V8YOUV4A/kizWhVprgAU9VHmUFo9TlLuLlCvnw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6513
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_07,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302100096
X-Proofpoint-GUID: 9lcKo2QmEahtfywDwWVloMkq19NHgxqE
X-Proofpoint-ORIG-GUID: 9lcKo2QmEahtfywDwWVloMkq19NHgxqE
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Yi,

On 06/02/2023 09:05, Yi Liu wrote:
> This allows user to directly open a vfio device w/o using the legacy
> container/group interface, as a prerequisite for supporting new iommu
> features like nested translation.
> 
> The device fd opened in this manner doesn't have the capability to access
> the device as the fops open() doesn't open the device until the successful
> BIND_IOMMUFD which be added in next patch.
> 
> With this patch, devices registered to vfio core have both group and device
> interface created.
> 
> - group interface : /dev/vfio/$groupID
> - device interface: /dev/vfio/devices/vfioX  (X is the minor number and
> 					      is unique across devices)
> 
> Given a vfio device the user can identify the matching vfioX by checking
> the sysfs path of the device. Take PCI device (0000:6a:01.0) for example,
> /sys/bus/pci/devices/0000\:6a\:01.0/vfio-dev/vfio0/dev contains the
> major:minor of the matching vfioX.
> 
> Userspace then opens the /dev/vfio/devices/vfioX and checks with fstat
> that the major:minor matches.
> 
> The vfio_device cdev logic in this patch:
> *) __vfio_register_dev() path ends up doing cdev_device_add() for each
>    vfio_device;
> *) vfio_unregister_group_dev() path does cdev_device_del();
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Feel free to drop my SoB. The code I added/moved at the time was very very tiny
in the middle of rebasing various series ... solely to unblock folks that were
also testing when IOMMUFD going out of RFC. But they don't justify a second
author SoB (thanks regardless!)

	Joao
