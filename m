Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8A361598F
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 04:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiKBDNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 23:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiKBDM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 23:12:56 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A9D248D5;
        Tue,  1 Nov 2022 20:12:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dGIdgBmvZgOrHrhiOfq4O6w/vGpArO+rgA/tTmpqeDy+VUeTanaWz5ZGB1YkQmmROhNgcQkuaCn786Q/KZ0w5+xCCo47cYeCpcOGJiq+ojPq0gO0dTVEkHBsYhv0UHnuOb1WXvNF2myCRhSECJHsweLH7uKwjVKdpfqxBZs72TL13Rz9eMW4CsC3wDIOvO7sBbaI0Rfb7nFsbNH+U69mx1tUxp672434ny5A/1Iq7Q6vr/mupibnhHOh4IPGhrMLLmIu7pK+CXQunOPFYj1J5XzUxgcz0T1wRRBAhgmgFFlO+crqifnmbV4NAwseB8yPP+f3pGotEPDtaUpOpZxn9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tg4MX7THNFepsOLzb4VnMTYev+mOtROjC+p9HcksrgI=;
 b=Xm6ZCtYqLUd91oqidS9PrvgXM+JsHx9vvELvkE3dNZj4uozlYy5H2Rc80FjCWs/F6AIqGKwxaFwjcpBV1LgKveSDNeHQL70n5ct9zwoH2BzjftBFqAYq8eFOWo7SUFE8DxAgZJfSiCILty+Ha3jJdF5RITAUG9jbgKmggpOEx43G4tAL9cp81nvpC/8uiLFiM9V7xuboVckeo4yKvbhhvioK/aU5R6T7cu+6GMzDs0t6ebT6UxIkRUs743nOrMqz4grnx/KOy3hz8oXGic4R2mHfmBSsazDq5bFUzWAxqsyNUpohwpXnq0DjoEWbEorjGsqvAKl60RkAqAXoo/zZnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tg4MX7THNFepsOLzb4VnMTYev+mOtROjC+p9HcksrgI=;
 b=Syoh2n9Td94y8GDmFsR2FAz52lEIjrQGLgMwWek5alMTnZ8NcSKFeWOh/9PG270ijJGwCFKEH6PsW9/0o4pcuI/IqyLH8bLLP1oZu8jDkIhxOgLnqEn7c4msQ0VZmw9NkWRkxGkG/1rkzZzBb1VomwQS3cpoEvTBwGS4UMbpJbs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.21; Wed, 2 Nov
 2022 03:12:41 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::36e7:b51d:639e:ed6c]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::36e7:b51d:639e:ed6c%3]) with mapi id 15.20.5769.019; Wed, 2 Nov 2022
 03:12:41 +0000
Message-ID: <6e9f3d48-1777-6710-cb1d-3f2f38c0328e@amd.com>
Date:   Tue, 1 Nov 2022 22:12:35 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 07/49] x86/sev: Invalid pages from direct map
 when adding it to RMP table
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <243778c282cd55a554af9c11d2ecd3ff9ea6820f.1655761627.git.ashish.kalra@amd.com>
 <YuFvbm/Zck9Tr5pq@zn.tnic>
 <SN6PR12MB27676E6CEDF242F2D33CA2AB8E9A9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <Yuu3ZK+/hL+saV27@zn.tnic>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Yuu3ZK+/hL+saV27@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR07CA0030.namprd07.prod.outlook.com
 (2603:10b6:610:32::35) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|CH2PR12MB5001:EE_
X-MS-Office365-Filtering-Correlation-Id: 4db076cb-bb39-40b5-0b72-08dabc801a89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1qGwUGxWYlrhaOA0LzaNIX1r4HXE3dGfiU+ZQgfQCk8wH3Hqb7d0NWJhGR5EKflabDIo1Q2+SwBrsHGu5chpR6LwcmB9YYlFMNHq5rZgK0qafs92YaPVWC/FdSEE9MJebYgBsqIzHgHKtGTByZN+/YoMEI7PrAnJlq5j0qlu3l8I13AvxrxvtdXILSmjiYBqb2IS4zZdY9iPIX8KCjaSfJjgwiRiJv/41VLhyyh50JMSKDPZ9hLveIp7Y3BUCWYx38Uw20sBR+/NxOvFBuGrm96GQQ8lT4EZ6MZ5VW315nnJJctLENFniClv4wGi2o7ELOu0BgxI3j9NfIlkfTD1t7B9KOv6yY9kHXJaOXaJaKu6SfLv3yZOCVoQ8o8UPXmlSyfqfp6N6GGzLA8ln7A/aA7XMvAHkgxKYaS+I8rDN2xLrvF0ozOfEekU0aoeSgkFDM9iyBSImHwsGWR3JmIH3M+Defnc/FMcnkrpssJB37bPTkqmOCRVc1c2Uon3PgEEACYW4r5tgzqEx7r8S5TEWL0srPL3gGHSx9qbeboTUA+loJwc5X9zYSkgD1hPU+287TMBtxtGjbRs+pGu2xF6LK7ajIuD3fB+F+yuQx8X8xUVa5Mm3xorI0/83RpamP92I+UPKlTcgPk7QvHFMY5yjvjZt1eE/ZqqpqjjFacXUfOKIsHjH8casS36NglXTqUuQrIsJ8OHriTnxzf0lWsxTrtiVXClHQW2oQP3xS2ZqNlkx0Dz4lKo4M6cV79U393BUiEEer1NX+qdF9ZAgj6UO+Czw+QC46S48N7MVVrhtIw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(451199015)(36756003)(41300700001)(316002)(8936002)(66476007)(66556008)(8676002)(4326008)(478600001)(66946007)(2906002)(5660300002)(7406005)(7416002)(54906003)(6916009)(6486002)(6512007)(26005)(186003)(31686004)(2616005)(38100700002)(86362001)(6506007)(6666004)(31696002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vkk5N2Z6QmVxMEJ3V240SE9LcFIrTWU5anpubmdWKzFDZ3FlNEJIYmlXbHZE?=
 =?utf-8?B?ZzFwVFJLLzJTTWo4WmtJcmpDNkxKOXNBcjFyMEdkS0d0OXZTYUErQ3hMUklV?=
 =?utf-8?B?aERmUnN2UkFjYTJ2TG5GdHNlUHd0RGtUSHhXWHNBdlg2Yk5xRWFya3ExY1pG?=
 =?utf-8?B?dFdFWTJ6dEtRSXBNbmcwLzM2Y2dwYkg1VkhJb2FnMHhNeTlmQi83Um1ObEMy?=
 =?utf-8?B?dHpxRHJua1RXNUhZeDkxWWVOMndQYUltdTlDaExjT1lSMjJVTVRyL3cwMzJO?=
 =?utf-8?B?b0JIbldlU2prdXRaN244dWRvd0VycWNrekgyTVNmMnRTTitjTnFJc2pjV3Uw?=
 =?utf-8?B?TGJQa0I1RlhOWHFCL2FDSGFWOUk4aVdZcnY0djFQQURTbE1ZQ1NiRnd4ck1z?=
 =?utf-8?B?b1pRUTZpVlZScE00cVB2OGlJcEIvUVJyZlJId3lyWHVZVElHbk1iQ2xvZllU?=
 =?utf-8?B?MDN4UVJTcnFLb0hoZ0JLcmpWYk5pL3VOTFcwY2dFZ3pFNC9heks0U05CeERh?=
 =?utf-8?B?V2lwZERxWHdiL2F3cjMwNFRwaUlUTXJHQ3FuRGRTL0dQQ2Y5VE1uYkRCMWM3?=
 =?utf-8?B?L3MzY0NQZTRMOHF6ZVdqYmZwa0hNc1NXblo5bHlDalM5aHU0c2hWY2V3OGJz?=
 =?utf-8?B?WExpVFJXZmtndCtmTEVSWFBFeXpFZGt5RVBPY2pzN3JuVWxDUEhnRmxWVm5W?=
 =?utf-8?B?THVXUU81dThTQjRSc1pCZ29yOWJBL1BQRXpSNG85TXFWMm1YZXFaQmUrWnNN?=
 =?utf-8?B?djB1ZUhEZGhnOGcxWUtRV0tKa1hhUTdFRUR4WHZ3b205V3pvS0NoM1hWUzVN?=
 =?utf-8?B?bExjdmxTYmI3azQrUStKR2NtUEVHY2VtVFR2bWpvTHdGRitjYU9BVGsyWEJ5?=
 =?utf-8?B?YWxGQU1NUWgrUUNzWUV1eWlEZ3BBWU01eW9GTEpScy9FTDhFTzdIRWNBblh6?=
 =?utf-8?B?elFkcjhpSXZFQjkwQnNmeDBzcTRXMGdXcjg1OUU3Rnh5SVlMYm10TUJnMWRQ?=
 =?utf-8?B?MUN2bksyWTF4UFI4b2lFbXhNanM3Y2tXZldTbTg2NXUxRm9YbDNxVU5aa0tu?=
 =?utf-8?B?THNrbm1wVkN1Nk5oTi9FcFpWU21PUlJzTitkTVE4TUFJQ2hadWpJVGlGS0hW?=
 =?utf-8?B?bmhjWFBoVDJ4M2Y3Z0FuVDRkRnd6OFNSY3diaW9hb1l5T0h2czRoS1VyYXFU?=
 =?utf-8?B?bHE3UW9SL3YvS1F1K2Z2WkFHdEpoZW5oWGFoMStmaldIbDV1cm0zdWZWeG5E?=
 =?utf-8?B?MU8rMkcvSXQweTNrSEdxUjNLNXp3SDg5WjFtQTVXWmUreFpEalRRVk03bDIz?=
 =?utf-8?B?S2xRbEgyNDlKWXowWENKZC9meG5GUnBGTTlWSnVyU1Z1YXhyejV1UVVVTzVp?=
 =?utf-8?B?S01Zdjh5bDY4cjZBOEdFSGZiK1hmdWI0UDdkSXpJNWtXOVMvT2VRRlByZlln?=
 =?utf-8?B?OSs3TjFJTGMzRTBLZFZ1S29STEFkU01YOW1Vam9NbjU1VGJmWUo2cDdjcVZ3?=
 =?utf-8?B?bXc0NHNMYk5nNjNSWWFZa25QMHBSbFNCQldHdnpQUnArWk45N2FVVGJIRTJq?=
 =?utf-8?B?dWpHQ2xJd2lmaStsRUt4ZnEwaytPNUJwNUw3R0VncjB6RlB6YkdKRDMremZU?=
 =?utf-8?B?NU1qb3NONi9qa3M2RjhoZ1VTZTJ0eiswL0ZtVUV3RER4SFJER2owN0ZxVURz?=
 =?utf-8?B?VHpHYXQ3eS8xby9YWlZuNXdqTmpEVTR2Q1VzdE1PNGdHYXdvK2I2WVJZOXUy?=
 =?utf-8?B?ZHozUDdaK21nZ2NmblY0dE52TDlKaGpHMnBEN1pqa1lkaEt0K2c2VmJCRE04?=
 =?utf-8?B?Q0pJUDNpMFY2azd3ZEp2ZFpHS3lwazhtMTVqSUs3aTFSV2hMOHluMHJHVDJm?=
 =?utf-8?B?NHc1VzY5TlBrTEgyVU5qSm5Gc3hYQjhxR1BXMmV6TUtlZGpRVUlLVy9TNXEz?=
 =?utf-8?B?K0greWZuODkyMUZoQ015NmRTK2hMdlZsalp2THJSd3dyWkZRblozakkxZ0U5?=
 =?utf-8?B?dHdjOTNBeE9sM29QZmtxZVNlY25ZLzc3MHFWbmRFcGo5ZWFOUVk1aS9XT2RT?=
 =?utf-8?B?aW1yditSdGRoakFhUk9qR0hlN3BOb3VwMGJBUmhqbDlFT09TcXFacTNPc2dW?=
 =?utf-8?Q?2EZMBLJZJgyughlxzjZiLdEkz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4db076cb-bb39-40b5-0b72-08dabc801a89
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2022 03:12:41.4777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yS5hU9OFetOd1i/2uqrfNPYNqREDFv+8RMCSJdfpeqxZIhlR3wR8aj2oCu/xUmZUier9cFK7FMFTS0O/Fuj7jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5001
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Boris,

On 8/4/2022 7:11 AM, Borislav Petkov wrote:
> On Mon, Aug 01, 2022 at 11:57:09PM +0000, Kalra, Ashish wrote:
>> You mean set_memory_present() ?
> 
> Right, that.
> 
> We have set_memory_np() but set_memory_present(). Talk about
> consistence... ;-\

Following up on this, now, set_memory_present() is a static interface,
so will need do add a new external API like set_memory_p() similar
to set_memory_np().

Also, looking at arch/x86/include/asm/set_memory.h:
..
/*
  * The set_memory_* API can be used to change various attributes of a
  * virtual address range. The attributes include:
  * Cacheability  : UnCached, WriteCombining, WriteThrough, WriteBack
  * Executability : eXecutable, NoteXecutable
  * Read/Write    : ReadOnly, ReadWrite
  * Presence      : NotPresent
  * Encryption    : Encrypted, Decrypted
  *
..
int set_memory_np(unsigned long addr, int numpages);
..

So currently there is no interface defined for changing the attribute of 
a range to present or restoring the range in the direct map.

Thanks,
Ashish
