Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CACF17CECAE
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 02:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjJSASN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 20:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJSASM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 20:18:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D48FE
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 17:18:10 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IIoxBs012584;
        Thu, 19 Oct 2023 00:17:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=K04C52zcVsPovueBS3w7Uz9c4AG4GdaVO2fpQSp8EHE=;
 b=loP2X+HqZbSVOEojONMZUreJwqD8pHppW2A6zdiwocp6hLu9nTVWYk/sASoANsXhcxPu
 fA+/k9O85iFx+6oZto7QbTB4lDVQAhNaLbBKD22KvF3pUFg7hUggcnPqdJ4Xvcq6NDFt
 y1lDYaJCfV/nv8yBhIqxW2pVsake4k6tLYKaKcpkaDoOh3zHAO9KGD7aloTOp0OHIjIt
 wJYpt8I0Emt41ukjr0TbcT5ESvlL2wVflsBZrR8de17TvqPRWNBX0RkaxgpzuoECJDEL
 yZbUgi8qTQvjTVVCPvvFdRXRA5s0aVnz+XIlvmwEI95bvJ4zGW/bdcjpRohbxc5dSRsS hA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk3jrxn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 00:17:42 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IN6g8U040652;
        Thu, 19 Oct 2023 00:17:41 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trfypfkys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 00:17:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmjOC846EAMswhDXgnQnXoB4e9ni4eLUUmzwY8Jy8JuuoWs8JM74TV9K6HwQsytfQZTpY6nIjugkbeHWf1zkyZ8PTIBXuet1MfQTlvlOcNO6YSXVf0+9ELqFtgm99rHbOfQ2prDheGD5ZH9s/o+lZtSPr2cGHPXbtdeJzNMPxXWZzL0m5FGeo8c2DCk/JbGGJ8e7aalPVJTNEDdO39bcPFffV49wIJAn9sE3nv5NRTcG8TSqokmI08TPgDcMRpyouRZBkoSIJ4yu7p89MFU0+CUgYDby8Pc6jZMtuDRAUSvCySz7GTjMEdCaWkBhE/aWFWOfnMI4IvMFTR0+3jN72w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K04C52zcVsPovueBS3w7Uz9c4AG4GdaVO2fpQSp8EHE=;
 b=F6Lz2TmNtp9NQwOf862UTvy6pRtQgW51kChCTp2KhoZD5nWccGsLkoWlj3PaPS/aTkdcl9MMirEsInIjaNyqnK1c5kR9AqUkJUQvvRJ/xyt2SIPS0bf1j4vNgEszIBf5BITM6eICxbCzpSDWOcNCi7I6/UOE4eREfb0wgjbUAgGIupqvCPn3VoJEI69dDac/VV0UuDaFBtS5Vg8c/J7VSiBfLOId3vBF90hPHQv8ttvfuGP5pulWAlibB7ikDAPHWNjbmc2aG4So3mHUwH8+smWgUGCZ0caX5asr+tDJ2joz29GS2S0vR3gLeAsRNf6mKmP8zHTjKRva62kOGG6TFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K04C52zcVsPovueBS3w7Uz9c4AG4GdaVO2fpQSp8EHE=;
 b=TIQ0QH97xkArHNClCtj1YzmL2eDYquPhB2DDGPvhDcxyNfSPapcTc1/jpvX3LqATKOWyz3se9ARB16Zyo6Ib6TTiqL/3RAF8HkO0iPJdzKGS+fi85/aFjQQnyieDQMHNTIfZg/W8K5N5RxZ8km/F/aApaiNntbz5Fkvzt7STiEY=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL3PR10MB6164.namprd10.prod.outlook.com (2603:10b6:208:3bf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Thu, 19 Oct
 2023 00:17:39 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.022; Thu, 19 Oct 2023
 00:17:38 +0000
Message-ID: <2a8b0362-7185-4bca-ba06-e6a4f8de940b@oracle.com>
Date:   Thu, 19 Oct 2023 01:17:32 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/18] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-12-joao.m.martins@oracle.com>
 <20231018231111.GP3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231018231111.GP3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0595.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::12) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|BL3PR10MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: 81692db8-2c58-49bc-35e7-08dbd038cd72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RJXk+DGs00XlQ/Hy7xnoCUVMz9KWEnEWRNalhoHsu3q7ewUIeUyzqjUjBZWkmmA6IsaZqnAXER+g5wMz1GRPsvDqqeh7yqQTJwEKkPwGQcFlsDzJcN0arcQqz0YeTlNkdDoVa5wTBTq8LBVDoX6tOQ4DfuaKiIEhwM7H1qS1JGklYhgCom24UDLUs1hjq6tTxslogdKWJkkeWa/oSx0d6BvpUmJnuAdSxjb9WS0JcCKVwNSiUGaOHpR89KcLgDGb5jvJ+7hejIYDdtNlzjvf3Qnw55uORxY/foi4F0PJMe99/a6u+ixiV6GfgLhmOzFQaXP1ihWt6aeAncxvAJRaunuufwoh2NyFpAuOv1afflo3H2nS/oOSXtWivbT9FaTd9UhPsArRrDuAXeYEtNYNib407sFfi9iF3INu4IAxDynRnl6LC9h0Pbgn+zPUabiOpzN7kgv0BVQkhOEt5XSfphtCSS65ttrDzLx7//8ALJsuBTyc2vJd5IappvUCLuRBwP8CwOe5IZvdGibGmxuNZyZr6NsYlaItLd2Sibhrx9kcJhp1oLGq4xWbNolXPJ9JDk3BfoG7WWre5Eq63+EFQyuneR+oN57l7QTPe2FOizAxo6hYw7JN7l/OKLPV10PvPdibypGxq3UejeCu0NyXnupkPYYE3myFkD3A0iKxvJw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(366004)(396003)(39860400002)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(6506007)(66946007)(66556008)(66476007)(41300700001)(54906003)(478600001)(6486002)(316002)(6512007)(6666004)(6916009)(8936002)(5660300002)(86362001)(4326008)(36756003)(31696002)(7416002)(2906002)(38100700002)(26005)(2616005)(53546011)(83380400001)(8676002)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1lONEJlYlU2RUVkejE0cjhOWXpsNXd4bWd5NXlkZDdHaHlhVis1QjdHU1da?=
 =?utf-8?B?Qm5Da1JwWno0NnN0c1dRd1AyNzF5eDhsVDRKQzEwWFkzNE9lREZlVFFVZDNl?=
 =?utf-8?B?SzBWUSs2RFNXRFdIOFk5dXNCR2ppZnBBTjJGOVJMTlgvYVlyZFNIQXpyRDMx?=
 =?utf-8?B?UlAzR1orRWh5NzhWZ0hNUjlJMVBqaU56dGJ0NG5BNzFJN1V1TUFEZTB3QmVr?=
 =?utf-8?B?NnVGbWlHMTBGZ2k3OVIzSFNIZm1iWFRpaktFMC9QaGRuK29PNzh1VmtaRXp5?=
 =?utf-8?B?cjZid1FHck8yL2Z5SzFzNWI0VnBnWUE1a0VjT0htOElvODNuLzk0dnFicGVU?=
 =?utf-8?B?SzE0cnVDMGZyMHlEWTU5djBPcmJCOXdwVTFhdEQ5Z3R3Qk9EUjdyL1JHdm1a?=
 =?utf-8?B?czFhS01CcVdYT1VIMlZiR1pnTGd5UGNZcmxDMURRSDRFdE9GTFZDK3I2OWpl?=
 =?utf-8?B?ZFlnMzVWQWhTTm96eHFlM2xaWkRmSjFZWVc3TitObVJwOCt6TkRNbDZEVU1U?=
 =?utf-8?B?UEx0MllMVVJXTG5Dejc3VnFKRHhLM1ZvQk9KT0tYRU5SL3RyUFRXd1liMEZk?=
 =?utf-8?B?WGYyb3dzeVBDaktkVVQ2eG9EeFpNZmZYQVZIZ3J6MXRkWEFFS1Y0akg2MUpQ?=
 =?utf-8?B?M1AvOHk3SFNWZlRuZFpNS1BCL0NqbHRpMnpaZ2FMVWE1cnQ4K2k2eUpOZnJ4?=
 =?utf-8?B?ZjMxRERVU0VYaGhrSEdZb1cvTDBXZmVvZXowUm5Xa21FMmdGN25qdGtmcE41?=
 =?utf-8?B?UVRRWFhTbWJXTmJmM0ZnN0lPUWxWcXdJMmpZaVYwakRUY2o3SnZBSWR3eXFO?=
 =?utf-8?B?VlZFbTNXMmFZdHlFaDBwNHhBOStyWXdyZzBHcjg5UmdCUFZvOTdmTURoSHhF?=
 =?utf-8?B?aC9qQklqUjJwTzNEZnBzeDMzRE1RZDFWVEwyRGRJZCtWMEJwVFJ5V1ZCN0My?=
 =?utf-8?B?bmtFSW5DVmZka1Fub1BVMktVNm9HY1RIT0J2WWxSQ2VEREJkWXZDdEhaR2Ex?=
 =?utf-8?B?ekhtK2tIT1lLd1BMVVFCQUhJU0NSVUQ1K1NJajhUeTRyNjdWMHNhT3pVaFpR?=
 =?utf-8?B?Mk90Zjk5eXJoZFUvdXpDUU81VjBlS2RwYnFqZUoyYjJvSUU1YU1zelhGTGc2?=
 =?utf-8?B?YkFVeXp2YVpzL1BrUnZsTmZXbFpUNm5jckJXeWRldHpJL1pvYThkaDVPRGJk?=
 =?utf-8?B?WHZrQ2VBQ1RFUDVlYmN4aVN6SXVNYVY2NVlCR2ZEVmp1aWtlREFWY1lUZDhs?=
 =?utf-8?B?N0N0NFhLZy9lb2VSK2xKdmpxdSswMnZvWVVIbkZzREpRT2EwcWVUc0M5YmRX?=
 =?utf-8?B?NGtMaytZZjE3NFpoTkpZeGRocC9MZVNueDEyY1I2djdnZjN0SVBJVE8rSzZz?=
 =?utf-8?B?ajJ3SkVYZW5jbjg4emlpQkt5end1S2o1dkppWWJTWUVDaktUcmtZdHA3TEt2?=
 =?utf-8?B?NlJkZi9zQU9KSGZLcGJIZk9FSEhnS2d0QkVMRDRrbzBKaFQvVW1sVjFMa0ha?=
 =?utf-8?B?Y0FKMjZ0aHVsK3QyY3hBWjd4a0ZRM1MrUVh2dC9USHFPUHF1Ky9QZ216VXNa?=
 =?utf-8?B?SUlJMmV4SXdXZ25zUWV5NHV2Q2lFb2FyVEtDSGVkNVFRNStaa1NKb0plSDA1?=
 =?utf-8?B?aTF2ejF3UnhZby9FcjhMNWx1aENndW8zKzE1RlFkSmErWEkxYjlPeCt4MEJ0?=
 =?utf-8?B?eTNqdEE5TUFWVUlyN05rSXE4Q3ZOSWxudjJ5NUhLaEQvaWxZZ1JDTjJua2tP?=
 =?utf-8?B?RTZlTXBIdjBzM2pGS0tnRHFsZ2RESG9SakV3bWo3dXhaRDIzakgrWFNlVG1X?=
 =?utf-8?B?YjdKaU1lUFVGK0xKa2pkUjNnWlYzVk1GdW00bEFRL2VTSGJyL0o4Z2ZkRW9L?=
 =?utf-8?B?d1NaZXo4M3ZyUzdnSkIyOFR6aWNtU1JLOHhIRnFXVVhQeFJZUlcxazRmMUM2?=
 =?utf-8?B?ZW1lZENjRnlqZWpQQ3F1aUY2OEkyOVZWbmZyOHprekVydkJmY1ExSHVZZExB?=
 =?utf-8?B?Vk1aNnA2MFJsaitEYm52azNPV2ZYYjNXeEl3a0NHREVUNkZ1VEdZYjUvMnNv?=
 =?utf-8?B?R0d0cFV1M1dlMzJYVHdnMzRQNTZUbGNCaU12VGJqYUpGVlhBR0YxUWdnQjhY?=
 =?utf-8?B?ZGc2OHlBLzR6OFQra2JCMEo2bndCU2tkQTlXTmcreGJwMGxOTkNuaXJQNlVQ?=
 =?utf-8?B?YXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Wng5VG5qMzBmdzh1Tmtwc0FnVDZoRTRPVyt3Wlc2ejRaVU9POWVaaUtYSnNw?=
 =?utf-8?B?SXRpZEZhYWlGSU4zVU5iMWJIZ0dtS0VOd1RzMFN4TGhsUXM0Yy84Umd6RkNn?=
 =?utf-8?B?Smh4Uk5iaXhlNTFQaTRndENCMzJnbitXV1pUZ0dGbXBtODdicjdQS3pVSTRZ?=
 =?utf-8?B?R3FVVG1FekNjelEwWmNzS0tTdTg1U3BRY2tGbzV2MklIMjdlbnBZZGZMSUNZ?=
 =?utf-8?B?Z1J6MlYzczhjL1hHcGtYcjZSVmsyQkJxRXlVaFkvOHFNajFLZno1bnFlcEls?=
 =?utf-8?B?RWx1eGJ6eTF0TWEwOTU4aVptMDZjcGVTa0YweWRtM05OWVJFampqWVEvZENJ?=
 =?utf-8?B?Znk0TklDbUJwK3pYWEZrNXRKb0o4aUI4RnQwb0UvYURoSjNmZ1prbElpZjkr?=
 =?utf-8?B?UXpZSkUwV0ltSms2R3pwVlRrenYrVlc3dmZBQk5lOTZoeUpKYXppRCtFNE5r?=
 =?utf-8?B?eXkzVTQwVktzenNUeWNkK1ZnTEtNOFA4RFZzbEtLNjdlS2Q3U3RGRHpEY0Rs?=
 =?utf-8?B?RkRTYWhrZ3VldHJSZUZONXFpM0FEMkd5cm9oVjZDV2ZRcnpzWWZGejg3UkJk?=
 =?utf-8?B?bHJVM0F3QmZpMzF3WTN1SVg4UnNkN01sclFsWkFZTkdkcldObTRocTAxWFdz?=
 =?utf-8?B?YW42b0pKY3FIMHoyM21RQloyMXVXcTJnT29FOGZkVTF1enhDQ1E2MzRuam9m?=
 =?utf-8?B?bnlBT0lJVWhsMkZlaGljVHZIUnVxbDAwUDBCc0pmL1hoc2IzWFZod2RqZWJv?=
 =?utf-8?B?KzJteUNIWVRRZ3pTbm9Ld1dsUFN4MTNYQkVycmRjYWczWE12SEdHbUUxTits?=
 =?utf-8?B?ZUkra3lhR000eHU3UUxoa1Fvckgvd2loOFo0MVZYYTc0ZUdjeDZCRXBoU0Jq?=
 =?utf-8?B?NjZnYWZ0aUNXK3dFbG5aRXRQaThhU1BHdm0yaVNDZi9Mc09pa3RocU56SG8w?=
 =?utf-8?B?VitKVHZJUllJR0o5WXVDb0xsUStVdTZUN2NkY2NrNDQzYmorTEhHNHVtcDFS?=
 =?utf-8?B?RVE0anhzeGFvTTN2K0xYeDhDbEhkSUNVRjBWRW9KUWhCSGp6REVtakp3T1hv?=
 =?utf-8?B?VUhIcFRvSDI1dkxoUDRTQnc3UjV6eHZFbmQ5U2hwV1lNS0xnd3pKQkNCdmpT?=
 =?utf-8?B?cncrK1c5b29FdHBVYVVxcy9uV2REUUQ2WUUwdTI3RFlCQU1zaWxzNnBsMVFs?=
 =?utf-8?B?SEhlTHRiZkNvVkx0ZWRqZVFuaEhiZG4xendSQ0J0SURDZXR0dTBjNGw0RTYy?=
 =?utf-8?B?Ry8wcFV4ckVqcDVVTnRNTXFCRzRFU0hDVTZuZGxNUDZFbTVoV3VuREFFVG5K?=
 =?utf-8?B?Y1RJUWdmUkFZQzdFRGVnZEVzZExZbXdVRDJNN3Njd0hwb0dxNkorQm12aHQ4?=
 =?utf-8?B?NXp1di9SRU9JY0R1Q0p4TGd6WS9QSTVKZFhMMlhQM0ZHOHNZT25tNm02VlEz?=
 =?utf-8?Q?sf/yQ+qf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81692db8-2c58-49bc-35e7-08dbd038cd72
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 00:17:38.8181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vx4uPKOgvBJG6vbL2WvQzeadVc8op7L80we9Tob31so31PX8fbcGRIMbOOX77761zNbKNLgeCz17O5QaurwcfBF2yxxcXedSbfLt7q6U9z8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_18,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310190000
X-Proofpoint-GUID: mu8A6_I_cDqSAF72iUmSx1YarFbpEgyX
X-Proofpoint-ORIG-GUID: mu8A6_I_cDqSAF72iUmSx1YarFbpEgyX
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/2023 00:11, Jason Gunthorpe wrote:
> On Wed, Oct 18, 2023 at 09:27:08PM +0100, Joao Martins wrote:
>> +static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
>> +					 unsigned long iova, size_t size,
>> +					 unsigned long flags,
>> +					 struct iommu_dirty_bitmap *dirty)
>> +{
>> +	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
>> +	unsigned long end = iova + size - 1;
>> +
>> +	do {
>> +		unsigned long pgsize = 0;
>> +		u64 *ptep, pte;
>> +
>> +		ptep = fetch_pte(pgtable, iova, &pgsize);
>> +		if (ptep)
>> +			pte = READ_ONCE(*ptep);
> 
> It is fine for now, but this is so slow for something that is such a
> fast path. We are optimizing away a TLB invalidation but leaving
> this???
> 

More obvious reason is that I'm still working towards the 'faster' page table
walker. Then map/unmap code needs to do similar lookups so thought of reusing
the same functions as map/unmap initially. And improve it afterwards or when
introducing the splitting.

> It is a radix tree, you walk trees by retaining your position at each
> level as you go (eg in a function per-level call chain or something)
> then ++ is cheap. Re-searching the entire tree every time is madness.

I'm aware -- I have an improved page-table walker for AMD[0] (not yet for Intel;
still in the works), but in my experiments with huge IOVA ranges, the time to
walk the page tables end up making not that much difference, compared to the
size it needs to walk. However is how none of this matters, once we increase up
a level (PMD), then walking huge IOVA ranges is super-cheap (and invisible with
PUDs). Which makes the dynamic-splitting/page-demotion important.

Furthermore, this is not quite yet easy for other people to test and see numbers
for themselves; so more and more I need to work on something like
iommufd_log_perf tool under tools/testing that is similar to the gup_perf to all
performance work obvious and 'standardized'

------->8--------
[0] [hasn't been rebased into this version I sent]

commit 431de7e855ee8c1622663f8d81600f62fed0ed4a
Author: Joao Martins <joao.m.martins@oracle.com>
Date:   Sat Oct 7 18:17:33 2023 -0400

    iommu/amd: Improve dirty read io-pgtable walker

    fetch_pte() based is a little ineficient for level-1 page-sizes.

    It walks all the levels to return a PTE, and disregarding the potential
    batching that could be done for the previous level. Implement a
    page-table walker based on the freeing functions which recursevily walks
    the next-level.

    For each level it iterates on the non-default page sizes as the
    different mappings return, provided each PTE level-7 may account
    the next power-of-2 per added PTE.

    Signed-off-by: Joao Martins <joao.m.martins@oracle.com>

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 29f5ab0ba14f..babb5fb5fd51 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -552,39 +552,63 @@ static bool pte_test_and_clear_dirty(u64 *ptep, unsigned
long size)
        return dirty;
 }

+static bool pte_is_large_or_base(u64 *ptep)
+{
+       return (PM_PTE_LEVEL(*ptep) == 0 || PM_PTE_LEVEL(*ptep) == 7);
+}
+
+static int walk_iova_range(u64 *pt, unsigned long iova, size_t size,
+                          int level, unsigned long flags,
+                          struct iommu_dirty_bitmap *dirty)
+{
+       unsigned long addr, isize, end = iova + size;
+       unsigned long page_size;
+       int i, next_level;
+       u64 *p, *ptep;
+
+       next_level = level - 1;
+       isize = page_size = PTE_LEVEL_PAGE_SIZE(next_level);
+
+       for (addr = iova; addr < end; addr += isize) {
+               i = PM_LEVEL_INDEX(next_level, addr);
+               ptep = &pt[i];
+
+               /* PTE present? */
+               if (!IOMMU_PTE_PRESENT(*ptep))
+                       continue;
+
+               if (level > 1 && !pte_is_large_or_base(ptep)) {
+                       p = IOMMU_PTE_PAGE(*ptep);
+                       isize = min(end - addr, page_size);
+                       walk_iova_range(p, addr, isize, next_level,
+                                       flags, dirty);
+               } else {
+                       isize = PM_PTE_LEVEL(*ptep) == 7 ?
+                                       PTE_PAGE_SIZE(*ptep) : page_size;
+
+                       /*
+                        * Mark the whole IOVA range as dirty even if only one
+                        * of the replicated PTEs were marked dirty.
+                        */
+                       if (((flags & IOMMU_DIRTY_NO_CLEAR) &&
+                                       pte_test_dirty(ptep, isize)) ||
+                           pte_test_and_clear_dirty(ptep, isize))
+                               iommu_dirty_bitmap_record(dirty, addr, isize);
+               }
+       }
+
+       return 0;
+}
+
 static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
                                         unsigned long iova, size_t size,
                                         unsigned long flags,
                                         struct iommu_dirty_bitmap *dirty)
 {
        struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
-       unsigned long end = iova + size - 1;
-
-       do {
-               unsigned long pgsize = 0;
-               u64 *ptep, pte;
-
-               ptep = fetch_pte(pgtable, iova, &pgsize);
-               if (ptep)
-                       pte = READ_ONCE(*ptep);
-               if (!ptep || !IOMMU_PTE_PRESENT(pte)) {
-                       pgsize = pgsize ?: PTE_LEVEL_PAGE_SIZE(0);
-                       iova += pgsize;
-                       continue;
-               }
-
-               /*
-                * Mark the whole IOVA range as dirty even if only one of
-                * the replicated PTEs were marked dirty.
-                */
-               if (((flags & IOMMU_DIRTY_NO_CLEAR) &&
-                               pte_test_dirty(ptep, pgsize)) ||
-                   pte_test_and_clear_dirty(ptep, pgsize))
-                       iommu_dirty_bitmap_record(dirty, iova, pgsize);
-               iova += pgsize;
-       } while (iova < end);

-       return 0;
+       return walk_iova_range(pgtable->root, iova, size,
+                              pgtable->mode, flags, dirty);
 }

 /*
