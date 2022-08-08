Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7476458CFB7
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 23:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244475AbiHHVdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 17:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244493AbiHHVct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 17:32:49 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAE51B7BA;
        Mon,  8 Aug 2022 14:32:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dtNx3pk0kEZylEwv6TYMVU3N1dQ5izjZMToAZA1U0g5oKlPGrAFj/2klx+BG+i9TfNd7+kTS73TQnu+o/uAhmABFzMbSwxC03SoXqMAVdOQ/kZpxGzA6q9iX+mg1MXJ4e/mjTixS6CYc16IC7DhZ5DfZFpftZxD0BVcDJJ56D9eoBDYwmJO2Ny78+EOELHTi7aqTDcNQ5GE5v1zq5e9lv7wlEq9R3610CObDhVO8zfzXXLvhBCQidaiFUsYt/CU4PoR/228XVTKWjPFE1+2DtdD8yfqTpnYgI+E0/Zyu12IaiogJFFy1NHe4R8XJJHkll2CjzrgVMR0onkF816DUgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xC3BhAcLZ3aZqpaaaUQuSU82nD8C/mb4vRQ8GjPXzyI=;
 b=QqtyeaXXxei+3gfaC3PwtFCDiS8EwFU38pg47CARQ3Nzs+S5QjgFudOwZkeDravrHrn06twU3eFbmXuAb2vTDY4Sb5wTyv+bunLJ9R4vIY/652lKEz8aSfRVLYItTFrnYI+28UJfqShJuRLFsbiURy5U2JfdDqEFKpN0dHA02fbCK8CbBBEDj048gNCBaS3Y081viIe+E06oYA9tI0A5KTgVQp4l3irG5ccOXdoaMsiAO2bdN9YYjpanHGkas0bt2tyvbNI6rcMk1rlQ4tIMPkzx0cvUZR06xbqnmJMhvWnBgWapE2vVXxR3E39pDaZBPDx7BpE6BCZJU6/qq3JwDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xC3BhAcLZ3aZqpaaaUQuSU82nD8C/mb4vRQ8GjPXzyI=;
 b=NlCv0r6XD8D5KqihgH8szcHueQIULTOwgjX79EBwq0nODACAqJOPlYmYY7pMR77pDfHvjwe+HjHTUKyvgdSl3Z2rjVRb5muZ4cPw+iBWaJBtlm6M5/5V2CVJ+9mwklvIIy6ldyh7ZWiuLZvWB5JarJWdjCzg5uDZgmFWwhym+BM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MW3PR12MB4491.namprd12.prod.outlook.com (2603:10b6:303:5c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Mon, 8 Aug
 2022 21:32:35 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1dac:1301:78a3:c0d0]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1dac:1301:78a3:c0d0%4]) with mapi id 15.20.5504.020; Mon, 8 Aug 2022
 21:32:35 +0000
Message-ID: <a4b82687-7143-35c5-ee90-003a9f2a088c@amd.com>
Date:   Mon, 8 Aug 2022 16:32:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH Part2 v6 17/49] crypto: ccp: Add the
 SNP_{SET,GET}_EXT_CONFIG command
Content-Language: en-US
To:     Dionna Amalie Glaze <dionnaglaze@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:X86 KVM CPUs" <kvm@vger.kernel.org>,
        linux-coco@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, vkuznets@redhat.com,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>, dave.hansen@linux.intel.com,
        slp@redhat.com, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        srinivas.pandruvada@linux.intel.com,
        David Rientjes <rientjes@google.com>, dovmurik@linux.ibm.com,
        tobin@ibm.com, Borislav Petkov <bp@alien8.de>,
        "Roth, Michael" <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        Marc Orr <marcorr@google.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>, dgilbert@redhat.com
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <d325cb5d7961f015400999dda7ee8e08e4ca2ec6.1655761627.git.ashish.kalra@amd.com>
 <YukZFKpAO5o5MLA1@kernel.org>
 <CAAH4kHazh_S4zTLimL3Bch7yo3zL2wv86j=w3f2n74O-joWLQQ@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CAAH4kHazh_S4zTLimL3Bch7yo3zL2wv86j=w3f2n74O-joWLQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0110.namprd04.prod.outlook.com
 (2603:10b6:806:122::25) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 742d70e9-05ff-4366-2aab-08da7985823b
X-MS-TrafficTypeDiagnostic: MW3PR12MB4491:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Orsqo9wr6j5zkkETS1h/+ZSxvbrBQeEXT6DKtPbrxmzXwcLytMw48BvFTiCbVkXbKUyd3GPsnTlS5XR8w1Ugua+ZTaMIg1pGyb28lIDe3lmK7faPN7K75o/rqlDE/9KV3A5zA9TEAiqI/lZmJo6JN6xbq+ffbfN1VxjztoYhNj+u8N1ud1TsFbuGXOxzFrlkqkFRd/LLr3123f8Oxu2NmExV6iUZpgNgVEPRCkOoCj2t1efEz7b5tHiVyh9a0bYBf72qJtpFQK9h3Gz1AjqPZb24QrPHhVKDCgjInS8rDvAbMu7AGyiwqL7bGfiLHzySv0sRXO4QsnARBOtpt8U9r9Bbvv1tJKiYeGOF6robNl09DIrw9gMQOr/DotQt0Gx56Emr/lv5QlpQod84gsMJvXPmQaEQPJ1o0Os9Kzy2RBwnaxA9iN9/SnLS/h9k4DGMtnmKtagtNwtrI0NjNDX3bljB8+cosmtsA12GfNe4L5DlmigzjuJB7K6zBsNZcKl8QxjLum1vnQ7u2zHUobR+0ckyEiuEgyzYuwn67gNrbff9eSe+tCIw/MEZ7jZX1HDUAez39VKYoEWsQgSIEWd670ax5arBOcjq+yr4YBQ89ypiqTMykHKbVeqb9yYxmj2/fcRGE5vP0h61qad444Hv7HydjgRTwVRSTqwjkuODJyvZnM2fPTbUD3MvA7o+FNJbPQtmvBC6YPLDrsR2oeP8cwjLcomEfCcL/7+lq/7d2OEaa28RRA0rV7zN/IlT/bMN0PH0KmypfEIQq4ZxK3XNZBWnGIzo0xgcSvIEU1FTG6FeMAAzduMz+g4kuw4j8PXQgXcEVv+Fn+ap8p8xOBbUtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(2906002)(38100700002)(66946007)(7406005)(31696002)(86362001)(66556008)(66476007)(110136005)(8676002)(4326008)(53546011)(6506007)(6512007)(6666004)(26005)(54906003)(6486002)(478600001)(316002)(41300700001)(36756003)(186003)(2616005)(83380400001)(7416002)(5660300002)(8936002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXpBWk9wSFhEaGtEU0JLWisxeGR1WUozYTZENDNRbmpkRWJBM2FWWXcwbnox?=
 =?utf-8?B?cnFhVnIrMkF1ZVpGTG9rY3FKenZDNkxSU21WRytybWQ2bWlML1l6TVRjMTdF?=
 =?utf-8?B?QzIyZTg0ZWo3WWlOWTJSbzgzM2g3WFpwZGI1SmQxakFLdHBqZ3MxQjRrWjQy?=
 =?utf-8?B?Tm9VQ3IyL3pZWFVWMUpObXIzNnp2ZFRtYWVnTzBCam9qK0d6aWtEZVVuVGxU?=
 =?utf-8?B?QVVRRjVLUEdOUFkveS9VaXNDYjNWb0hrL1YyQklPaUJ3VDRJN1NXY2tvaXRV?=
 =?utf-8?B?WGhPcTRIbFFtNGdidklLMm1LMmUxTWZVK1ptWGFSV1poQnZNcTZHRjl0bXdm?=
 =?utf-8?B?djhBWjZ2SWtIcjhSTzcyYit0ZDRlalNZaGZEOEZkVHA4ZjJqSytGaTRYcTJR?=
 =?utf-8?B?WWZzMi9CR2wzQVNMMVBqZ2lYYS9vWUtzVDAxM3hBNUpBZkdnTldGWjNLeEFT?=
 =?utf-8?B?bENZSWgyS0ZUaEdldlhEV3lkei9lOUFRenFpM0VTeUx6bEM4Y0NJd3FGTk00?=
 =?utf-8?B?TDhwMDlXR2tmYW93alVuQ0c2dkdkZVA3MWtEeXdISnl2cWZIQnBSNDM2eVpr?=
 =?utf-8?B?aEowRi9EVW1PZTMxV3VBVWJhbm81QWN2NEtGaDdWV2RsMk5Idk5ueFJiWThU?=
 =?utf-8?B?TlQ3L1RaWE40QVUwOHlWRWtRSVJpZXppeW9wUXF3Qjk5anNxbEtkUkFpYncz?=
 =?utf-8?B?dlZQM0hjbjRJKytiZWRFaHlCRmdOYTNaMFpNczlqR1lJNWgzRUVmSXdlSGdw?=
 =?utf-8?B?RUZyWUxQMlphRXdETVE0c2djNnJTNkxjTXA2QWY1SGNBYmRDa1JKdWlTa2hn?=
 =?utf-8?B?SzZOYWt3SEJCWnZjSzQ2cDFveHJrajZZMlVTY0s4UTBhQ1h0UGRvTFJYYlNU?=
 =?utf-8?B?dE9QMVhBTHZCUkl6OThBS1czc09xN1pFZzRreGhDTTd0VUdiRUxDUVcwYStQ?=
 =?utf-8?B?MU4wQkhIeXRkcnRHSDFIMlNWYkJYTktWNmN1NXZXdUJUVWQ2YVhwYWc2YS81?=
 =?utf-8?B?akp4THJFVDVXNWlrS0JEMnFBT3ZkZGVaZWs1bTdNSEgzRDZmWEdJbmZDZTFN?=
 =?utf-8?B?cWVaNkJFTWQyZEgrWktDYTlWVGZPaXBncDlMT0JoSElnZDBGWlI4akNiSXJz?=
 =?utf-8?B?cFRXYURQN2gxeDc5QXZYVTNSNHlWUmR4ek45NkI5T0QxSDZoVHRGWUJXbms3?=
 =?utf-8?B?eTk2RDI1bkFjdXEweVBWcEdHTFVJK2NEQzBCd3dUdlk0NURFZ1VuaW0xai92?=
 =?utf-8?B?ZDBza0J1RXZiMVMwc3JEektiVTJGa3l4SE1samtCbFJrWlJLNjNTOCsrdUVs?=
 =?utf-8?B?Nmp4WS91SVhWazdna0ZKN1VVN2NzWHVDYWV1UzBMcWw0UVZwZXJiQU9lNzdC?=
 =?utf-8?B?NlRqcm5qUlNYNXAvZWwyVnZWaFhIeHRpcXlZVElheTgzUTBoTzJEb2tCbXQ1?=
 =?utf-8?B?WExDQXREZjF3L20yRFRZQWhNK0pnS3lLYk0zTE5UUzBrSEZWVzJoWXNkbmZx?=
 =?utf-8?B?WGNPdVh6SXpNVGxVc1dhYkpYTnQrM3h1Q1ZiL3B2ZXYrcDcwZTluOVlGN3Y1?=
 =?utf-8?B?OVhsbnY3a05JOGc4dFNDMCtObWhIU1UyZmFPYkIvUGFqbTMwUytpYVE4SmhS?=
 =?utf-8?B?NEpiM1FsRnNRZDlOQzRXL1ZENlhzRGRZem5ZSnB1dEdobVU5UE44Wm9EOEt6?=
 =?utf-8?B?MjliZUZ4L2tYWjR4M1p6SHM3dk9HSVg5a2hFcTR2S2tEdlFDcFA1Z0Y3K3Er?=
 =?utf-8?B?SDF0TGRlejZraFVYZDRUb1Y2Qk45QjAveDNrWnhCUHFxSk1aY3NpZTNZK282?=
 =?utf-8?B?QUwyckVwalZEQUhlT0xGQVkyNU1hN3hhYkU3WHUyZVZWMnBlclYvcTg3N2NJ?=
 =?utf-8?B?SWRSM3Q0QlF1S2RpTngrWXJLcUxlR3M1aUE0SUoxQ2gyUVJKZGM5L0dUYklr?=
 =?utf-8?B?UlN3VzlZWlY3M3J2ekVjK0xaQVR2WXRrdGNaQjM4eTNWVDI4YlRFR0VCUzBH?=
 =?utf-8?B?OVg4aWhRNUVJSFFsMlg3UTJHWkJwMHQvSjFqcm1LemY4dVhyTi9IS1p0STNo?=
 =?utf-8?B?SFBCaDdXVTNGZEpYZE1oUnd1alVJQ1ZSRHJROXNBWGhJTXRWZ0t1NC9Vajlj?=
 =?utf-8?Q?+Ev1D86L+XAMzpBuKRw38p4Mr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 742d70e9-05ff-4366-2aab-08da7985823b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2022 21:32:35.0904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zEUJoPDHs0LSjIPQTf80fxUrtDm7HH5IEvXEHo3EcVVUisYViferk/thNuhCuPBd2KESceonOW6dGDumfyqNQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4491
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/8/22 14:27, Dionna Amalie Glaze wrote:
> To preface, I don't want to delay this patch set, only have the
> conversation at the most appropriate place.
> 
>>
>>> The SEV-SNP firmware provides the SNP_CONFIG command used to set the
>>> system-wide configuration value for SNP guests. The information includes
>>> the TCB version string to be reported in guest attestation reports.
>>
> 
> The system-wide aspect of this makes me wonder if we can also have a
> VM instance-specific extension. This is important for the use case
> that we may see secure boot variables included in the launch
> measurement, making offline signing of the UEFI image impossible. We
> can't sign the cross-product of all UEFI builds and every user's EFI
> variables. We'd like to include an instance-specific certificate that
> specifies the platform-endorsed golden measurement of the UEFI.
> 
> An alternative that doesn't require a change to the kernel is to just
> make this certificate fetchable from a FAMILY_ID-keyed, predetermined
> URL prefix + IMAGE_ID + '.crt', but this requires a download (and
> continuous hosting) to do something as routine as collecting an
> attestation report. It's up to the upstream community to determine if
> that is an acceptable cost to keep the complexity of a certificate
> table merge operation out of the kernel.
> 
> The SNP API specification gives an interpretation to the data blob

That's the GHCB specification, not the SNP API.

> here as a table of GUID/offset pairs followed by data blobs that
> presumably are at the appropriate offsets into the data pages. The
> spec allows for the host to add any number of GUID/offset pairs it
> wants, with 3 specific GUIDs recommended for the AMD PSP certificate
> chain.
> 
> The snp_guest_ext_guest_request function in ccp is what passes back
> the certificate data that was previously stored, so I'm wondering if
> it can take an extra (pointer,len) pair of VM instance certificate
> data to merge with the host certificate data before returning to the
> guest. The new required length is the sum total of both the header
> certs and instance certs. The operation to copy the data is no longer
> a memcpy but a header merge that tracks the offset shifts caused by a
> larger header and other certificates in the remaining data pages.
> 
> I can propose my own patch on top of this v6 patch set that adds a KVM
> ioctl like KVM_{GET,SET}_INSTANCE_SNP_EXT_CONFIG and then pass along

Would it be burden to supply all the certificates, both system and per-VM, 
in this KVM call? On the SNP Extended Guest Request, the hypervisor could 
just check if there is a per-VM blob and return that or else return the 
system-wide blob (if present).

Thanks,
Tom


> the stored certificate blob in the request call. I'd prefer to have
> the design agreed upon upfront though.
> 
