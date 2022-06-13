Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F65854A279
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 01:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiFMXPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 19:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiFMXPO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 19:15:14 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2063.outbound.protection.outlook.com [40.107.212.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8342AE11;
        Mon, 13 Jun 2022 16:15:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AdA8fLiBnmZU/KltQ6FtjPI2PIKBm1pJyu9lUHA5+BGMfnkdBolaIEEeYwOensp1kaM+6S2duXGEVwjgio2akvneyUuTq6VIum7why7daPSU0EcQPg7MJhdak97A8lwLBsZWbQbEU2gXLpybPJc2sNsqgd1rZ+P7HAd6AmdTRp3SWEM34I5DWsEFkOSUzzo+MnHujsSTNNLgvUKBO0fPpolBHnzpwZ6SusvK7/iE4IoRBsvxUXRYD4/lmmAMyg8BqALqmPH1v9AuxjeQw7BBYWg7RTooj8d6V7whmytBQ0LvQs/50DnoVnzf+Mu9ZZy4lZ29kYwTqRVRGdzL9wvUjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IKpQmUllgLEabAbwcOznJGAcPX730nOFU7mWF7MTAdI=;
 b=lHCc0x5wQhv6EJybS79yngAuIzv0wMHO+r4T0vHqV5C2O9yoLXtG1McE4TzT6YhJC6HNchJ4/SLVgKv32Xzj9kCEkieJ5x00WdS07rdmNfI6F6XoVUSlL/6VUCm4tMHoN5mH54HtjTPQ7MB2LQfy7EH8lEFqDWfc2SpK7ZWpCENIlO41kdmqwabI2Wea1BM1PwNj5ceae/w7nrhEOdB2Ar53Mfy9Vk6zvMeSHgRwGHFrk4/zXVvBiQ8MW+O8B589sH5eaDpQkRBiXp1RdgwbE1UM9jjty0WRoZLNcDVpaKqrAzPlq32ztkNnE8Mfd9thQKs4dXqCTiFcS8pp9QkpHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKpQmUllgLEabAbwcOznJGAcPX730nOFU7mWF7MTAdI=;
 b=YCoHOQikUTF/57340d6q2yThq6ObHDpHPhBoJ9gxzu9QCWEjLfe4ZzALtTJ9WQaH3vWdqvAj+eZFYJ5IlR1YKWK25g8KIgg90TiFR0mmrT4SgVkuGz1jo8Ka+o74SG4im1xymxFLDR7KrRik5wGxr8fKxLDz2W08lq+YP0g9Dns=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BN8PR12MB3059.namprd12.prod.outlook.com (2603:10b6:408:42::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Mon, 13 Jun
 2022 23:15:09 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::810a:e508:3491:1b93]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::810a:e508:3491:1b93%2]) with mapi id 15.20.5332.020; Mon, 13 Jun 2022
 23:15:09 +0000
Message-ID: <1cadca0d-c3dc-68ed-075f-f88ccb0ccc0a@amd.com>
Date:   Mon, 13 Jun 2022 23:15:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH Part2 v5 23/45] KVM: SVM: Add KVM_SNP_INIT command
Content-Language: en-US
To:     Alper Gun <alpergun@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, Ashish.Kalra@amd.com
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        Marc Orr <marcorr@google.com>,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        Pavan Kumar Paluri <papaluri@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-24-brijesh.singh@amd.com>
 <CABpDEukdrEbXjOF_QuZqUMQndYx=zVM4s2o-oN_wb2L_HCrONg@mail.gmail.com>
From:   Ashish Kalra <ashkalra@amd.com>
In-Reply-To: <CABpDEukdrEbXjOF_QuZqUMQndYx=zVM4s2o-oN_wb2L_HCrONg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0040.namprd02.prod.outlook.com
 (2603:10b6:207:3d::17) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c437d3c1-02d1-4ea1-8570-08da4d928f19
X-MS-TrafficTypeDiagnostic: BN8PR12MB3059:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3059610ABA71F0D4C5B8FE9A8EAB9@BN8PR12MB3059.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bcicaZdmOrVhQaAPG5CqjTcyJZ14MvmgDdej/1NG6h/VBFfdhh235jPiEX6mqDu3Sl9UjYI1bVvf6d3OW51r1E08W9q4ZYx4XIHGr3LcT81TYPjUwaLK18xa1bLZQCXOnpDHqhEC8CYVEgZP0CJhr6tHlzmgmSJLV6v8PFyTHUi0qBhFfE23BJ0kx+sDPVnOPGwxwPtrg0O7VMzGMKIMU1vqLG4ZGjjdr+mwkrBWJVZeET5NJu2x9cFnmHuKya82QwEt0yfrjHPTKFzRTTcStnizjZW8nV7kIlylCYfWJRypsg0rdgCSR2Q0uJ8VHa7jAGx2WDXKFgE0y4s3ifnKeEtYYLJtmyBnE8Z14xTO0O1ThnRiI6RHuGlsgz7m6Xf7Llc21LoC6RQv9YDN4CI1Zg63g2KpLEZGP6U6wYghRRCNfiw+tv3RL0huKESC4d+BsNE/gZTmRldxpEZPBL7u206nD3NKKVhUL5sRnaU0XAx8/xJg28mKAaiWHMYaQtpb85dl02gTLaCY3CAGVIxU13tNRrd17BH4Io0lAy7e/0fytemTQq7XJvYRpCo0OxKhdEiimIn2gIPCBsUt3qG8CebK2qp2yYdiUjC16bW/B1HyPIdo0rXVBTx1BSFvszOgVvOjhESoSsaEAuRX3b7LT+mrjv6nhkhgVog/f64dwIHogilPbKX0dMdCZUf/FVTvcWQ2lTaGIWtNv4rZC1PJxM42XIDk0ExixNdZgH2Aod0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(8676002)(4326008)(31686004)(36756003)(7406005)(7416002)(5660300002)(110136005)(66556008)(66946007)(66476007)(6636002)(6486002)(316002)(2906002)(8936002)(26005)(186003)(508600001)(54906003)(2616005)(53546011)(6666004)(6506007)(31696002)(6512007)(83380400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlZ6aWMyOXUwNHcraU1FKzdSZGc4Ty9vcWl3eENTODMreHpGMGYzbkdPTHFI?=
 =?utf-8?B?NlgrYWs0WDhPR09jZGR0ZUFQMnNJSXNyKzV0Wll0TlVaeThMMmFhN3R5dEJn?=
 =?utf-8?B?U3hLeDl0WCtEdCtVNlJ0U0lOc25rR3lDUnduaDVHVFFyZGdtNzh6ZFFtajJr?=
 =?utf-8?B?eTQ5MU5NcUVwTXkzbVhFZGxrTEV0RFpaYTRTaVFEZmZqWnd3L2pmMTYxOVhp?=
 =?utf-8?B?aHJLaWxCb0xpeFFuSWxDU0xhY1BUaERVK3VSVXNtSGNFQ0pCSHdIM2FFL203?=
 =?utf-8?B?ZUhoUC9MME9ZSm5HbE9yeEF1R0Qxa0JHWHhPWEFTYTNLOWxqRlViVHdaZzV2?=
 =?utf-8?B?L211RkdmZk1yNnpPMlhka081MDgyZmc5eUtBbDBWTGVxdTNxSGtqd0M0YUUx?=
 =?utf-8?B?U2d6R0lxQUowdGVZWVN4b2ovNEpkZFNTNmdOamExandKZG1RRmxQdlEvc3U1?=
 =?utf-8?B?cnFBSGxGaktmUCtOS0FPWnVBekpzdE5nK2licXErUUNBWnJJcGdybFpvTnpx?=
 =?utf-8?B?TzJkaU5CK3ppQVc5UGdkL1BHRHNrb3UwSERPL3lTeDd4ZjRnOFB6dGc2cWN1?=
 =?utf-8?B?OGl0TXZBU1lpMEI2YzFMMDByT1BkQnNsazRqWGc0M0RFalNwVVN3TEFNYzQ3?=
 =?utf-8?B?TmF1QXpVQlZxYmxCbEdESnh2MXd4b25wWVR4azl6b3NMb3RRa0lzOXlUd2V2?=
 =?utf-8?B?RW9KZHM5SHBkbWNTR2tiekpjUzZmdkU5eTZMdkJ1SHZ2TjBNbHh0VTJHY0lL?=
 =?utf-8?B?Z2RyNlorNEFUVzFEMHlxOW5mL0lGOCtHMnlzNkl4WEF6S3prdkhsaGhYSktC?=
 =?utf-8?B?YUttQzdjQmlXTUNmNksxdGtBTVZPanNSU05QWStaaXhqZFdCNlJ3R2NRVnZ0?=
 =?utf-8?B?SXlxRk9uQXJ5aE41RlVkeEo4aDFUUTA2cWd6dGo1cEovYjR5MnordWlWSlo0?=
 =?utf-8?B?MnA4K3o2M2dEMnVuSm9yYTJycEFsQzVieHY0MnN6NUN4eG1NdnFnWWtweW5B?=
 =?utf-8?B?QVliY1kyNjFveUNvOW5QMkN1dGRGQm93NHlXcW0yNnRrZnk5ODFoK0tXeURp?=
 =?utf-8?B?dHhKK0ozMC9GQVZUQVM0NmhpdDJhcnhQWVgwL2FWME5OQkNTNVIyZG5DNmlV?=
 =?utf-8?B?UnZUNHNSWUxXdWJMN0cvK3c5QXZxUjQrY0p4aXB0Q2xnTFo2K3NuSG1ENW45?=
 =?utf-8?B?cWp0RVVUL3JSbkczQ1VMVFNJd0YxTy9NaHpFNnAweFhTbzJNL2dTK0FUL2p5?=
 =?utf-8?B?TzZINjhOb3p6bFNDTTdSNDBZNzJuRnQrSWVsQXhBdWxLZC94NDhmT1RhQzR3?=
 =?utf-8?B?eVFBN2xtNHdnMm1jRGNMeDU1TVRCRjJHN0l1czI4eVhEdDRlV1E5QVJpY2FX?=
 =?utf-8?B?dTBwS2g5S1pZRXc0ZjFFa1p3dUxTcWlTSmp1QXpWcFk1cUdMdytaSGZnaWVq?=
 =?utf-8?B?Nm1RVDRaK0k4WEI0OTgwTmVrMmZ1NW9BU24vSmw2QTl3NUZjRFVlTjhaUVU0?=
 =?utf-8?B?RklhWWFrWWFSNk1yZlFPRDhqOXA0WEdIMmdqaUtNK2NWcmZMK2pYRlNBV0FX?=
 =?utf-8?B?Z0U1V0I0a2lmME9vZHFHT0txMDBtRU1sZTdESStmUjVnQWJtYU5Fc2I3SDF4?=
 =?utf-8?B?dVRiU09qYytNRkFIY00wai9Mdjg0ZzdoOFI2cm9tOE43WC9KMFVjMlVkNVZH?=
 =?utf-8?B?M1c5R1puSmRHYWRvZjdYRGoxQlkxTmJaVTBiTHdxUjhqbmQ4bDRMY3JmSTVK?=
 =?utf-8?B?S01HN3J5MGlnYWRvVlFIMVNzNmRXWmtscDJNK05ZcDJjZ25MckIwNklOdzVq?=
 =?utf-8?B?Y2Z5SGMvWjNjTWVkYjVLUWxTV0lQamtiaXpOWERUTFQzbGhjN2Jhcnk0cWp1?=
 =?utf-8?B?dWx2ZUxUS0xXSkxXMkxUNWptWlBQSFRNYThtN29FM3YyRmFnSlhRaXpFZFVD?=
 =?utf-8?B?K0Yyc2djKzNJdXBKSktqOWVMbFhjVUpodU5zK3pWS0ZjV0pxc2F3enE1a2N5?=
 =?utf-8?B?NmRoVVRCLzBkanBhM25aSzhsZU9LK1loaS9uenJmVWV2OWQyUGVyYVBMN1ZQ?=
 =?utf-8?B?TldCZFBIZFdmWHRkZ3dBZGxwK0NpMFRiMmQrSXg2TE1kUUxDc1FnUFE2YXpD?=
 =?utf-8?B?WXFlQ3hxR2UycUQya3N1Zk5BTFN1VHRQdG92VzE4aTVVSzlMUDBXYzVEWUI4?=
 =?utf-8?B?bHNMNTBYYmZNVnpQRVg3SzM4dEl6Y1pndVFqRjE5U0NTUWxhbkJkdXFsTnhH?=
 =?utf-8?B?MTc5TXdEMFpJZW1zYWkzUC9ja2g5R2NaVjJqSVlldTNGajExQ3RUaUFOSVhR?=
 =?utf-8?B?Z1FOQ0FpMGc2b1poN1FtajAwTUxQT0Z5TFlVajBPMm43OEh0ZlMrdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c437d3c1-02d1-4ea1-8570-08da4d928f19
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 23:15:08.9443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fJKxti27ZlYSgcywgjW20wcBGirhr7M4xeVFETh3qdBukOwZgf35yB++E2PTDAUC6j+wm8FlqWBY2mp6aWmaIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3059
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Alper,

On 6/13/22 20:58, Alper Gun wrote:
> static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>   {
>> +       bool es_active = (argp->id == KVM_SEV_ES_INIT || argp->id == KVM_SEV_SNP_INIT);
>>          struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> -       bool es_active = argp->id == KVM_SEV_ES_INIT;
>> +       bool snp_active = argp->id == KVM_SEV_SNP_INIT;
>>          int asid, ret;
>>
>>          if (kvm->created_vcpus)
>> @@ -249,12 +269,22 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>                  return ret;
>>
>>          sev->es_active = es_active;
>> +       sev->snp_active = snp_active;
>>          asid = sev_asid_new(sev);
>>          if (asid < 0)
>>                  goto e_no_asid;
>>          sev->asid = asid;
>>
>> -       ret = sev_platform_init(&argp->error);
>> +       if (snp_active) {
>> +               ret = verify_snp_init_flags(kvm, argp);
>> +               if (ret)
>> +                       goto e_free;
>> +
>> +               ret = sev_snp_init(&argp->error);
>> +       } else {
>> +               ret = sev_platform_init(&argp->error);
> After SEV INIT_EX support patches, SEV may be initialized in the platform late.
> In my tests, if SEV has not been initialized in the platform yet, SNP
> VMs fail with SEV_DF_FLUSH required error. I tried calling
> SEV_DF_FLUSH right after the SNP platform init but this time it failed
> later on the SNP launch update command with SEV_RET_INVALID_PARAM
> error. Looks like there is another dependency on SEV platform
> initialization.
>
> Calling sev_platform_init for SNP VMs fixes the problem in our tests.

Trying to get some more context for this issue.

When you say after SEV_INIT_EX support patches, SEV may be initialized 
in the platform late, do you mean sev_pci_init()->sev_snp_init() ... 
sev_platform_init() code path has still not executed on the host BSP ?

Before launching the first SNP/SEV guest launch after INIT, we need to 
issue SEV_CMD_DF_FLUSH command.

I assume that we will always be initially doing SNP firmware 
initialization with SNP_INIT command followed by sev_platform_init(), if 
SNP is enabled on boot CPU.

Thanks, Ashish

