Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5D87D3E62
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 19:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjJWR4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 13:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjJWR4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 13:56:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94281BE
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 10:56:33 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39NHq1i5013634;
        Mon, 23 Oct 2023 17:56:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=GspmDm8VJfaDECZ4N0yRhwCN1SWOTUO0NkKAuYE3E5g=;
 b=IqTa/amGL8gK+sGVQz2/MuWw7fvAAwuUa175nnmY9Bf4nweXeOjlISG5lqt2IZ3b7cSw
 BTUw/Jq0HqdMqR8hpEYdccrDTcFxdLFpZM94M7f6XWIvKcaqBzoiLY2bg+VdJF/tFbc+
 YNjcQNaDvPr3G1Xbn44Z+21m/FFIJ8JFRDoaDDA9tnKqW/AMar1TaXZqSqeXFuJzdGFw
 bp5u9yYzOtCTi4YPaakfWRieLGmeTClwo1uonFazO7PcsCwDAnc3oawxVjxwdjCVVfac
 osmGsgmSBZi8Cl8bujhU8t8zTqUU7boFYTOj4Tbq7P9KyqufQXOZJZs8I+GjEMX3blbt wg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv76u3nse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 17:56:05 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39NHKati019507;
        Mon, 23 Oct 2023 17:56:04 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tv534hn0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 17:56:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4ylCi5ZKNE58l+/wqU8qyKWbgtshNMadLLgCxsr6Dja8JiN6BomQnfEh3XSnYFIRQj8UFQSbFZnS8RQeOztBy+3fCWjcwJyguSPFONdYj5QeT99tvGHUNgPHKm+4Xc51hkJyJYlQiDyM8U5uv4gfOP636o48EbNKlOFGTmLxG1cwVa5MaGYLtPTVI42HGjlTw70cYa1rGQr8zI+amrmOPzyRWG54ncBBh+SFZQ0yruGnn+1Y96tv1L4g6E5e1K+ePM16b6SOlAoMqX1q6LmWsDsVLJj2RG38DN7oxTXJ5HOwbtJ2CJEVgs55DQxtUR0JMX2tAxHVJEGPPnt9uS4ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GspmDm8VJfaDECZ4N0yRhwCN1SWOTUO0NkKAuYE3E5g=;
 b=COPt+dwls1jVrL0IguEMRVHtyc0d06bj/hm4KQNA/lNY7uh2PaO/+RWfEZKedeHRKChwn9m8MbJWMKuZC1HhiROq5dyk0AJFFga4+BTEcs0JzNh0OeV+SSIg/EaO/YX01YLBSwim1iIScATFzb/lB2kRePS9rRIAmnC8pahsZv6VGW9WKGVrzDYAzxY2dM4adrFNtp0SRDDNi89i/vcXqj+br+LnNoe499ZtfIW3W3D1OqRn9us1NVLUJr1Y3thuns5avC9syKOZcsgIivzCUE1tzmj35RnrYZyTGn71+fuHW2xHkRzTto0/HNdnmAaECgnj0UZ3xVI9XeoW5DjGCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GspmDm8VJfaDECZ4N0yRhwCN1SWOTUO0NkKAuYE3E5g=;
 b=eiHkBD3D+mp5vDIgMHQoAQzbhOOA6nHWVom2jf1ottBGA8+PAqRb+tpGy2vh4xiOe7X/UpSHL3hL+Oj7FB7zYpIi6WuUtXEOn09rMeJUEGvS8Ps298WuLlDD3uqp7V5+5D63D/mktlkrigB9CzZiqL6kbOsD9yrq1Zm3kzUaKCQ=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CY8PR10MB7340.namprd10.prod.outlook.com (2603:10b6:930:7f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Mon, 23 Oct
 2023 17:56:02 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac%3]) with mapi id 15.20.6907.032; Mon, 23 Oct 2023
 17:56:02 +0000
Message-ID: <5069116b-11c4-40ea-bfa2-91313ee4fbe2@oracle.com>
Date:   Mon, 23 Oct 2023 18:55:56 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_BITMAP
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Baolu Lu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231020222804.21850-8-joao.m.martins@oracle.com>
 <b7834d1e-d198-45ee-b15d-12bd235bc57f@app.fastmail.com>
 <d65cb92a-8d2c-41a3-83b1-899310db1a20@oracle.com>
 <20231023121013.GQ3952@nvidia.com>
 <5a809f02-f102-4488-9fb2-bd4eb1c94999@app.fastmail.com>
 <7067efd0-e872-4ff6-b53b-d41bbbe1ea1e@oracle.com>
 <20231023161627.GA3952@nvidia.com>
 <f511e068-802b-4be2-8cbd-ae67f27078e7@oracle.com>
 <20231023163411.GC3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231023163411.GC3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0211.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::7) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CY8PR10MB7340:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bbd5d74-0efc-4fdd-c542-08dbd3f151fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I/ej29vGvsFNhl9aE+iv7Yy0E1jYFfuCT0ROHSnZ3rAhtm6SnNi2PvNRCXhLcgJfjRHGY1H+UfED5xftIgIlu2t8dM1eXw87F0vCa7/ytcs2hhcEX6Wn3hjvG2opnxcxQH+pxugoiUS1Q/BNhxzPdne+ObcvHz6NEkkLsXBuEs/Rovu3QjzObEd8w0oXT8v9WRhBYFdYZgFVWn03lzDHxd/Sw5hp5u0NFYsjijl5l72N2nIYK+w177mE4xgcNz+VFq5iXLdKKoV5XZ67RRf+CDGa94gz2h/Msz8vZWo8G4ZJMd4sxyBiOwN8uxiN7pSbs0UFdfQj4w6EEyAJV8SBaw+x3KfWr8TaKNRQwfI2emllIObcGWqQU3GVLuD17KiY+x6G3KtNbDBzufQ533cvU9OWpATcIRge7BM4DvlTNvKKCwg9gyPE94rJ7BX9rnhOheFlSouGkMQVp9W6NrbL8HqdP8Oj1gDrci7gXDY5fmkgtBeANQwuNFeuWCRBcauOd+ZEmNPSxywtQzACd/7/A9H6n7Fs60pKIiHMb3se/sAFO0FPaFJnF0X+Xb5nt+hV3xfBHz4dNC7r1Nv7KsP62VCu5mhaY/iMrQjXXseI0tr88an1PGiODXP1NXGTkuDdTeGMxVzBDXO1XESzhambdkpc4KKY6GlTPfdqYLGbY5o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(136003)(366004)(396003)(346002)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(2616005)(6512007)(6666004)(53546011)(6506007)(6486002)(8936002)(8676002)(5660300002)(4326008)(7416002)(41300700001)(2906002)(316002)(478600001)(54906003)(6916009)(66476007)(66556008)(66946007)(31696002)(38100700002)(86362001)(36756003)(31686004)(26005)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWREbmRUU1o0MXh4cW1YN1J0UDRvZ3dEMDlDQUg1NXpQcTc5ckY1dklLVWhm?=
 =?utf-8?B?WXd4ZWttUERKN3JoSHpBZittK2pCUzErSzBPcG8zbS80MjFqR2J3ZzFxdko0?=
 =?utf-8?B?cXpXN2ZOOENRUzJtY2hkcXFjMWRJTkdVSDJ6aVlKWmFDeTRSVjQvMStLbzlQ?=
 =?utf-8?B?aTE0TUpYZlBRQmErM0lxZmxtNUFtcE9ITVBqQnB3WmVsZ3N2anlsMTRFQWc0?=
 =?utf-8?B?NXpOa1NReUdyaldacGFXRERtN1RScDY1NFE5ZlZLcnEyVWFmZ0w1cGppb0pC?=
 =?utf-8?B?L1lOOThISlF6MForVHgzZFRjbFg3U3JESXJCUjBPRFpZZ0JuRTVOUnlhei9J?=
 =?utf-8?B?Zlp0OFBBYUlJc083SWRPdjlOS2pjQWhxZ2xObm1CejNyK2E4amNtL0xLem05?=
 =?utf-8?B?NUFtZlAycnNpT0VXcVk2T3FhZ2dBT0taRkJyeWl6eDUxbTdUQm1PMm1VaHA2?=
 =?utf-8?B?K1dkYTVZbGNlbndoSndwMVlUWlRlSXpTb25yZWE1WFd3Zi9kem00SFo2dVhG?=
 =?utf-8?B?OE5veXFXRUU4Q2FpWnR3akxpdXVaM1hkdE9oMUJwb3lnV1FCTndpdzlQVW9D?=
 =?utf-8?B?cUxZV3diajBVMnFVRlNkWmxZZGVtRGlnVVJyc3hvcmp1aytJeUVGRnZ3d0pW?=
 =?utf-8?B?d3o2bm9QUDk4azlhbTdBd0twVGEyeExiU29jVk5HUGo2VklLV1o4Yzg0N25y?=
 =?utf-8?B?Mjdwek4vR1p6cWtzc2tOZ1RXcHJHSmZZK1ZOcyswTnBXdDB1ZFlQWFhqRWZl?=
 =?utf-8?B?RTlhbkZ0cW5WQ1RoVkZiL0hOc1k1dE03a2JjSXh4RVR4LzVoejFTMFdmNDQw?=
 =?utf-8?B?VmNFL1p2YW0rNXRFN1B4WHZXcFc1cG9SSGhCbWNyRW0rOERRb25qY0x2TWZL?=
 =?utf-8?B?T0kyV2tJMHJMQmVEQ0NYSmY0eFBBeUQ4UXpicEtLbjFOcTVDeTJMalBRVlpo?=
 =?utf-8?B?dHpsL1htcGFvMHVNNERnRzRyMmxxRDRtZ0plTHk2MDJnZUlkelRyWUVJckd6?=
 =?utf-8?B?bjZmdEgxcUVVMzZtZzd4T0NCUXpPKzJlY2pXRmRiWGtQTlNKdFdOMXNuTmVK?=
 =?utf-8?B?aUtzUm9JNk1ZKzc4NlIyVHJreHJMeHlLajNvaU9XVmRFUFhyaDNESzZiaHpt?=
 =?utf-8?B?VE1ZdGdrUWFNTDdpd1hZQTlyWFc5QlJSUGZveVJIdUZxKzBIRi9jUGthMlNY?=
 =?utf-8?B?UEtWV1pWWE1UYzBLVVdUbGZhTCtaR2ZYVEVMT2F3ZzlTNDFIUFRJVlo0KzRU?=
 =?utf-8?B?a2lXSldSK0I5ZHhoTlNQYVIwYjAxYStiNVlwWWkwVkEra1A4V2NaMDhJV2xn?=
 =?utf-8?B?SHZnbEh2cm9aZGlVS2Y4QXRGa1BPcTdYb0Q3K2p4cFZCWHRNRTNvQnZBNXc2?=
 =?utf-8?B?RlNZYWRNTlVmZVdsVitGNFZIUHN4d29GT2padWo4T0VGbG91RHg3YWFQU0oy?=
 =?utf-8?B?Y0JxTWd5ZEwweUdZSEdtTjJNN1lRaXJHeHZ5amwzK0xBSjYvQStVVDl6Q1VT?=
 =?utf-8?B?UlZhWk5DTDBoMXBJNnRHWWVNZDJhK3dWZmRtTmFSS21WYkhuRy9pUVVyS1V1?=
 =?utf-8?B?R2kvdHZiRDRHZEpCU2F2WkVrM1lKbE9hNWZmalZFajFobTVEc1lhZWlmdFN1?=
 =?utf-8?B?Z1R0NlNRekVDa3UwNWFOalp2V3YrL3ozRFBlcTJkZkxleDNLbk1CUDdLbTBs?=
 =?utf-8?B?bWxkVTRoRmNtZ0ZCVDE0UzRGTEFpMFJSczNPNlV3UGVLaTdPRkF3aVFsYy9R?=
 =?utf-8?B?QUxJT1JBdXNTTWxmdXdtNmFkaXN1cGlOT053NnIzRTVOSkVwdHBxbjdTWFFT?=
 =?utf-8?B?c2xkN2xSdVJLZVBlZmNLTlcyazd1a1dQdDlUaG9PR3VqdVFJenJGSGVJa0hu?=
 =?utf-8?B?dnkzMGpMUUVqdUJpZ2Z0eFVaNllObysrUkZ5WUlXWkVJQnNWTEVDMFJVQm5U?=
 =?utf-8?B?eStmQnBETHhzeEtTTkt2bGExWDZtVmE1bmVMVmFIa1hFSkRDL2xKWC9KVjFK?=
 =?utf-8?B?bnQ3dWxhSTgrN0hHeU9VU1NWVEdIZnhtcFIycXVITE9BU3FIa0FoTENYMVBn?=
 =?utf-8?B?Q2ZqTDNxK0R6TVY2eGpsdlZTbWV1UE95VHJXb25KVENUR2hQVUhxdUsrQXla?=
 =?utf-8?B?RHVkMTh1NlZZVEo1OEJZR0Q1VTFnUmFYZEl4QWt2TU5keUpjMnF2My9EVkNo?=
 =?utf-8?B?TkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Y0F0eXk1SjRUWkw0REd4MktzQy9XaUlqTlFUTHhuQ2pYRXRtbXJZbGJHNDBG?=
 =?utf-8?B?OWU1Qm9ZcmpvWVRxeW5RdlluUTJ4MHdRUHJsN2hydmFkN3JKOW1EbndJR0Rx?=
 =?utf-8?B?WEo5Z0pGMDEzaEZ1SzNBZ3ZqYU81T2ZqN1BqdG5RanRFL2QwRi9zaGozWndm?=
 =?utf-8?B?dnQ2ZCtVcno5b2xZNmVwWTRVY0ovVU5TZXpLa1I1OXNsQnBFQStFZE9Ub2dt?=
 =?utf-8?B?VXNXTUIycXMxNFVqMHV3ekxDVjNtRGdyaVl0UXF2L3NsNkpGdDIwbG0zd2E4?=
 =?utf-8?B?blBzNnBJMXg1L2czK2p0UDZ5ZTY2TUl6NDJxczdnSlczZW9VSFF3YTUzK29L?=
 =?utf-8?B?NGRkMnhpd1lZS2RsSHVzVW1YMEdzb20rbzVhNTg1c2tKaml3R3d0dnJGVWxI?=
 =?utf-8?B?ZHdSYVJxM1c5WVdUeW9GS1JGaWNjc1VsNS9Yck1KZzAyVFJDMnlNajA1YzUy?=
 =?utf-8?B?NXdib3NsUm9SeVBSVE5aVVJ6OEJwbU1CS1p5N0Z0YmhJVndyZDVoMmo1YmhI?=
 =?utf-8?B?R3FyZXZLWGtYU1U2Y2VZYWJsQzRGMDhiR05qei8wYWFkTkljSlNyOVljRmh2?=
 =?utf-8?B?QThUMEdKV0lXalNBMmswNFo1KyswZklFdmdoZW1WWUF5YmRVNVFNc1AxNm9G?=
 =?utf-8?B?TS9CL1MxQWZYWEdVb0JqRUpRQmZKVzZseWtKbGZkdUxwME8xRTBSbUtqdzdL?=
 =?utf-8?B?UVpYWURpL2FrN2FCUDhVZEkxNTVLN3RzUHV2OGJlMFdRbU5qYUVDcEdkSGNG?=
 =?utf-8?B?elNXM2ZEVFYxYXlFZm1yQVRpUkFUTEFMdmZMeWZYWi91N2R4YXN5SzJmT1RU?=
 =?utf-8?B?QUltV1MwRng3N1VuMmhQUFh4ZG5qTVRNWE1ZaEtwWjF6NkZScTZmODczYjZT?=
 =?utf-8?B?QWpuN1RWS0owQWkyc045QzlYSHVSMzNIY3BLcW5OYmpiZFpKRDRHaENBR0sw?=
 =?utf-8?B?OTZHQ3JCalBGMllhRHBhYlBQQ2tid0lVc0NFN0VXRGMwNi9VelRWbUtPQmhW?=
 =?utf-8?B?SWNBNXdJRDJVZ2JSWVRBQ2htczBCUFdMNlNGc3VNa1ZrcjlMZDBLclBhYXEw?=
 =?utf-8?B?M2ZtdGVVaGRtZWQ3ZzA3M1IxeHJXSFVzUVU1RXpjTFRMbUZmRENLSWhkWGJt?=
 =?utf-8?B?dVFNaHZYNjFML0pYbzk4YkpKVlZIL1pHVkJHRFRET3c0TFJ6R215a21UQXhT?=
 =?utf-8?B?dUtaNzVmZHFlVTAwR2JkY3NtOTlLcUJhNHMveXdVMVNFeHY1L2M5K0ROS1J4?=
 =?utf-8?B?LzVGQ0pBVFFDRlZoQTlhZklBZndycmZaRnFyb20xT3NLR0pUOUJxSUJqMU1W?=
 =?utf-8?B?RXRndHlIUkpCRzNhK1hqNjUvWlpnSlcrTlJVemhKV003dWpxKzJFVko2RjlP?=
 =?utf-8?B?YnJuSERWK1BZVjg1QUJKOUtxMUdhMWlkdkNySTk1eGhRQUVEazZudm5YT1RB?=
 =?utf-8?B?RXpKWUFuQ3lCV1ZHbXgweTM1Y1JnK1JuQ3dMZHJ3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bbd5d74-0efc-4fdd-c542-08dbd3f151fe
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 17:56:02.1195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JQJlU/nXr4iraE4g+Viz/K8TN2tSjYX1+PNAtLgEwDUYdwWtV+BUgdFbOnS+TYWMjbiofNxyKIbks+fGjp4Y0waP8piNZWI+Zpno1sj4UlA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-23_17,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=855
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310230156
X-Proofpoint-GUID: E1UaPQ3QlldoNXIXNZMvGP3rVr7q6kQ3
X-Proofpoint-ORIG-GUID: E1UaPQ3QlldoNXIXNZMvGP3rVr7q6kQ3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/2023 17:34, Jason Gunthorpe wrote:
> On Mon, Oct 23, 2023 at 05:31:22PM +0100, Joao Martins wrote:
>>> Write it like this:
>>>
>>> int iommufd_check_iova_range(struct iommufd_ioas *ioas,
>>> 			     struct iommu_hwpt_get_dirty_bitmap *bitmap)
>>> {
>>> 	size_t iommu_pgsize = ioas->iopt.iova_alignment;
>>> 	u64 last_iova;
>>>
>>> 	if (check_add_overflow(bitmap->iova, bitmap->length - 1, &last_iova))
>>> 		return -EOVERFLOW;
>>>
>>> 	if (bitmap->iova > ULONG_MAX || last_iova > ULONG_MAX)
>>> 		return -EOVERFLOW;
>>>
>>> 	if ((bitmap->iova & (iommu_pgsize - 1)) ||
>>> 	    ((last_iova + 1) & (iommu_pgsize - 1)))
>>> 		return -EINVAL;
>>> 	return 0;
>>> }
>>>
>>> And if 0 should really be rejected then check iova == last_iova
>>
>> It should; Perhaps extending the above and replicate that second the ::page_size
>> alignment check is important as it's what's used by the bitmap e.g.
> 
> That makes sense, much clearer what it is trying to do that way

In regards to clearity, I am still checking if bitmap::page_size being 0 or not,
to avoid being so implicitly in the last check i.e. (bitmap->iova &
(bitmap->page_size - 1)) being an and to 0xfffffffff.
