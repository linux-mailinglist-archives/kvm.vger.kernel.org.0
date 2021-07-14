Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9143C8B4C
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 20:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhGNS4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 14:56:31 -0400
Received: from mail-dm6nam11on2080.outbound.protection.outlook.com ([40.107.223.80]:8210
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229491AbhGNS4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 14:56:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JcUBK47xuLjCXxh5Ja7wIujfxLUVYm021O0XoJHjq49eaMjmHwRVTrscL5bnq1gljJuTp09mYFFb7bOEI/lbKfYDBLrkcB83bt/4Lc/d/6B0F6YXsjysnCtCkCIyy3JUeU9xvBICnyG5+Fje3S+8uoPsFVqLd1Deun+fVbUo4XW8yuWymvRS+l9yr0MVOrZalocC6OOgEKUPMqx5NldaLL0pyM3+stuApmjiowwZeXh1414tfuVr6tmqU/SZ4ZSIzdVhs5Tzo5Mlqu/iUpuTBEd9qNsWuinBHA9lDBgYKYd2r6288rhcp/FkYRzPFC6gXUk9GxwONsfw7aRTh1KjVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KDetNGIcJ05g8/YxduvFbSvSJujnG6wEVmbvo5f2tIA=;
 b=RAtW1nl/a/pc9YfSuyxAWhAgw3LUpAEW+wWkPB5KZu+udlhjsakt6q996u2QuXzGtAwv3JMAApFYH2WehzL1UuP4ZGQK0/28Zm1t+uwCQfNKaJF0QmXVmkGYZdPm25uYcfc+Hq7SuX/zGr9DfiDO+EQyES2sbFYPDm8qxI7IMfMHMXe2gaxBoM1vukEN6JqMY/nIFs7cnYFZcFYbbaAACwxVhP4S2LG/poqYE/FD7Pnwibn72cPbVrGkzoSH1ksEEnQowmqJTRVxnF8kBuD5FPluX3Y9ZGBLdfGE/+Inw1yHeDBxDT01DKcu9LvBHZav2hPhDfMgZ2Kd52MK21HNqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KDetNGIcJ05g8/YxduvFbSvSJujnG6wEVmbvo5f2tIA=;
 b=y06AP87Uv6phz2x125UuG8XYDlp5J6Q701YMu22n3htgRF0o/m08CTU745t7eXwThPZEYuq5Jy3WPoaeYAWdSTSmjtBwcDtm0p7+P0T+NhDNAsjwxWpQhLtkQV7v+6eAUfgyyeWxSH2wf1R8Mym/MII7/0T0VJ0k10IiEz8xgGs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Wed, 14 Jul
 2021 18:53:36 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 18:53:36 +0000
Cc:     brijesh.singh@amd.com, qemu-devel@nongnu.org,
        Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 6/6] i386/sev: populate secrets and cpuid page and
 finalize the SNP launch
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-7-brijesh.singh@amd.com> <YO8fBDve7yOP4BZi@work-vm>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <cf9152b0-f280-a1ba-1824-764616e84a0e@amd.com>
Date:   Wed, 14 Jul 2021 13:53:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YO8fBDve7yOP4BZi@work-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0801CA0003.namprd08.prod.outlook.com
 (2603:10b6:803:29::13) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SN4PR0801CA0003.namprd08.prod.outlook.com (2603:10b6:803:29::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 18:53:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c054427-1a52-47f9-e034-08d946f8afcc
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384FC3FAC007C7E72FCDD51E5139@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KwWdwqmXgt41qmYu5hjEU9SLZGZjX6nNWsw120Pz1LPBB8+Oyot9nTi5uPgRX0rfYR+Phr5GYCio1pv5y/Buc/9XENQgDTe5wZ3ePVLyKubDnO8lyJ0SRdegLj1d2mLIFbkMn+0+SaKjzsyZM6lVgiKteBqADDoZNUfPTscNFFJnSgZRvFxnv0l4VbzGJGIThftYctgsHn6rK5EWOs/zUqjsgEGxx2CbyYZKrMPP1e0jq36L619bGJr+atyNZHloh53ytpjiFxZZEi8HpL4eLe1320tr+2+9butZjhgsJp/sSxYZEOLYLuWbx/E9M0b84A7WSr/lFqYxBXv5eY9dxbS0yOI8uF07uOuMEcBTl5HJATIqcf4TxINI9Wv/vdIWFa7V1CIGEuXmA+9ZEKhd8ZSzGN6D3+8D/IHMaeax2H6ytWSqIfHv/QmBuR8XlIn0K6I8ngs1fZW6X9h8Besx9r0Uoka6eTwHjrDmrrJR3e3kj7n27VgptG3A2kDKpZ9hCEzLE1rrj1nKJTm8jFML7q9zH8NwB9e1vUcF5f5qn2Kj8qvaSkJFcUH+oqkzUun0naPLMt0Rr8OH+bWoJF2PlkoGXv8Y5uAclmKVdrY51dXDr4eAOQFt2b7YjTrDl48ZNbB9eZcq6jX1PL1PZqT/ZPrndnKgI8BZ6r6jNe87eSBJfZxYyNGKLNfD79sqPM5MlqCyZJzAbNTTzG3jce4u5XPVE+PpzgUb6FyZFmIW8wTnB5tjq/Yirsg/tLudbLKXcAxIG2B3jedqWbhxYz5ZLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(54906003)(4326008)(66476007)(36756003)(558084003)(316002)(8936002)(83380400001)(16576012)(31686004)(66946007)(31696002)(5660300002)(2906002)(7416002)(6916009)(86362001)(44832011)(38100700002)(478600001)(8676002)(186003)(6486002)(38350700002)(26005)(66556008)(52116002)(956004)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWVlN2c1SFROYURrdFFTcllnSlFzRXhVWlJyd3EyTzJKdmJFd2ordkJ6aER2?=
 =?utf-8?B?SHZnSm1SRkFpUHVjZnl5SEwzcUhrZDdhcnRIekhNSkxWeWhsSjgzSllyWk9o?=
 =?utf-8?B?eDFzNzM0VktYYURNMTcvK1hVV09ZTjU0MXltcGVyanVXay9qK004OW1Fblps?=
 =?utf-8?B?RC9FVWh6K3RESGF2WE90WnpJbEc4V0xEaW9VZnQwMWlWVVNUUVRlRzhRMFBj?=
 =?utf-8?B?R2FXL1FEWmVFNDR3K1UyRENaZXV1Vk1GWkVnWGh5LzVIQ3VZU0gvTS9MaXlG?=
 =?utf-8?B?Q3paY1RqT0JEK3lnSnhLdWs2WjZ0eDhMZ2hCY3E0cE9oQXBvYzBZb0pKWElC?=
 =?utf-8?B?QWNEVm11bnZRR2ZvTGdLN2UzTVVEQWxGS3BUSVhNN004Vlh3Wlp2YzEzVG5U?=
 =?utf-8?B?Lzd3akxxM2phNDYvRUR0bVg5bmVVRWJJUHVINHFmWWJFSjhpVVBqU0pRdnFT?=
 =?utf-8?B?R1Bqc0VPdC81L2FwelJuTHpqMkdxR3RVTmtITEIwbHViVlRxVE02bStjVld5?=
 =?utf-8?B?UUMzZlZtTjMyV0hKWllKSWQ4VTNhODVrK2ltYlhxRmUrZ3h5Ykk3WTd3dTAz?=
 =?utf-8?B?VkNpejlxYnVaa2lMRVBOck9Ic0dVZmFaRFExb1NJbmpIMVZRUUpnRXJaSE1V?=
 =?utf-8?B?U0wvSDN2NnVod1BVNGZuVVdwU1loYWh0OXVwYVhjNGM0QTFKWW1RUjV3TnBU?=
 =?utf-8?B?aXRFSzVhZnpCZExxeEFoczdxL2FjTjcxeW9UbEt5TUtLOFRINkZUcjZVRWpQ?=
 =?utf-8?B?Q3hDdTZUbGg1Ly83UnpVdlJCMUh3RFlkT1RxMzlKVmhTamx5N2IybWE2YUJp?=
 =?utf-8?B?S0c2UitSRW9jaWdBOFYwNDZEcCtsOTNnbnl5UXovMzFHWnBvNm9tY3JkL0dC?=
 =?utf-8?B?bkFReWdMVmtoNWFtbmozVGRPVHFCeWIvOHdrZ3FkNGY4ZWYraGlpNjVYVDhr?=
 =?utf-8?B?cDUxVDBYNmE0bmFEbEljQmVhb0JrckR2YWZVZE5sNk1CUkxZZXEralVydmVD?=
 =?utf-8?B?MCtIdTBYZXdEa3F2ZVBTZUFvZkdCWGdTcmZpT0RsNnAxZmhTSXBvUE9aRmhJ?=
 =?utf-8?B?YThMUkVHMTFTcm5XZDB6Uml5cTdLTGhtZ1dTdUo0Zmx0MnJCbTdjaCsyaWhY?=
 =?utf-8?B?TDJWclhUNGJYZ1RjL3gzbnFxUHpKSk5Ma2Z4ZmJneDVTQkxWNGhDOC95K1N4?=
 =?utf-8?B?ckQrb1NFbmJCaHNjZFEvd3FNR3dpbHZiWXJlMlVPcG83RFhmR3VxYjREMlF1?=
 =?utf-8?B?YmRaMHIvbCtveEVjM2lWend1YlFQTTNTVjY1OHdiSDRQZGdKN01zYUVVOEJ1?=
 =?utf-8?B?TXltWUplbmRsejRzK1BBZTlBMjhFd3BtajNkV1R3NkhRbGphb3lYc1pDUU9F?=
 =?utf-8?B?YktnMmpPNmtqZDczd0dPM0xUTmp5SmFqTk9aUkwvMWErQW11ZUtlaHRaaDJH?=
 =?utf-8?B?VU85WTNHanRKc3JNdjRLK2tpbUpSaFd1MFJ0TUZMU2ZjV1hObW9JSFR3dWIv?=
 =?utf-8?B?NFI3TUVPRXVxaVp6VDRGOWYvd3pnbTd6QTZTc0tDTENLNXVIMUZ0ekhNaENv?=
 =?utf-8?B?emkvK2VnaGtCWk9LL2pvY0l3Njc2WlZmQmhQREJVNi9kbXNHNFduSkFVTnpl?=
 =?utf-8?B?Y3FvT2hHWHFRRUFKc0JmemhlbnR1WHRRZmcvT1Z1R2FDYjREQndKQkVIOStG?=
 =?utf-8?B?YUd6aEFucXVIcjZ6NFVYNkx6aWFrSjVBOTNXWUhQYjJaQ1VsVktyOXVyckli?=
 =?utf-8?Q?gXmfGarx06+0S89cBc8EuQ8Gl+FPCwz/IK+wn4C?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c054427-1a52-47f9-e034-08d946f8afcc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 18:53:36.6268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SMXv9ZcHPRtJA13IAaHg0Nu+IoEnvi8Yn6NZEiyZzgCJhNBoXbR02uIqZE0F8h6VAJ+gFqYs36iTCioWYs9FHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/14/21 12:29 PM, Dr. David Alan Gilbert wrote:>> +struct 
snp_pre_validated_range {
>> +    uint32_t start;
>> +    uint32_t end;
>> +};
> 
> Just a thought, but maybe use a 'Range' from include/qemu/range.h ?
> 

I will look into it.

thanks
