Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98AF62D515D
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 04:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbgLJD1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 22:27:54 -0500
Received: from mail-eopbgr750053.outbound.protection.outlook.com ([40.107.75.53]:38046
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729246AbgLJD1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 22:27:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LoJx2TAEfFqUnI3jfEqwrOy49X8OupYP0RklcvV6o7zlQ4PQSDdXhXZoPz8pPGU2M1ZLReKu9BnNe+yYJycJMmcD989hPVOmxGYI3Wygf4PRKxnAIDanMyYXaNdZbVYICe8WKuLwYrBMOAkSdYUgFlSOVKVp2VkyyWYDGNIUBtOTlo5xteq4rFEp/7Ed1PWXzV+QNz7e9mYfDd7Z4FUwk9JAOCIsLvaMpCE8qZTtbqNetjE6HAHhcXvQomEg4JLu8zMt2OyP2iGhFf88RRukL4B2GMzUU+6QdVbdo1OIdr2MG18sHRloqZpvmbS+tB020mMqf23zv1zpH9+P0d39lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dmrJqEP5gyDFlMYM5/3vGIX0DcbVWJ9jw0y4V/ziODI=;
 b=eiMt0tGDjKTWqsX/WeIVz9r3auguhcoQ5e5Pdg+uR0EjhSLUVnphPj/6B/ZvTUtWvf7KyrRMRd1ZZ5VvOaTSCyMqUONB7/LJW0U0yjs2po67ZWBb5iv70ROjHuCb/6avKenQT4T27zoy7CrLqweqzYdz1coeAgMbBxVh+qRXMKfCdzUG9K0mZL0N4aNyvMeRKg4vrpkCAQ05Iz30uh9KnfSJ7X4im07BU+6w3zhK8urNqTMU4HpXcX0VTqx5ipJjjl88zvCII7VIbAr60dLgtJPybR5wD1EIXe1xLJJ+BF5JbQWOu95vfJsh5tUbPFNOTeSQh3spCMBWV/5teE1PRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dmrJqEP5gyDFlMYM5/3vGIX0DcbVWJ9jw0y4V/ziODI=;
 b=QEd/IPNAzGfkfGTp1LtUM9xTeqXDkqrj+/YNGat19daHFHTnxFC3fM9llPRVhmROpH8vMmqs+auuVtJX5eZmU+bcD8nrTtICEoaCPLkqNadhJ94MeYRLpBc42BaW8eGWSnddHrhiHqjPRZyb8uzCp1ponaNDPMeXXMPe9afcrxU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB4671.namprd12.prod.outlook.com (2603:10b6:805:e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Thu, 10 Dec
 2020 03:27:05 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3654.012; Thu, 10 Dec 2020
 03:27:05 +0000
Cc:     brijesh.singh@amd.com, kvm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] KVM/SVM: add support for SEV attestation command
To:     Ard Biesheuvel <ardb@kernel.org>
References: <20201204212847.13256-1-brijesh.singh@amd.com>
 <CAMj1kXFkyJwZ4BGSU-4UB5VR1etJ6atb7YpWMTzzBuu9FQKagA@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <78e18a3d-900b-fac5-19ca-c2defeb8d73a@amd.com>
Date:   Wed, 9 Dec 2020 21:25:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
In-Reply-To: <CAMj1kXFkyJwZ4BGSU-4UB5VR1etJ6atb7YpWMTzzBuu9FQKagA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: DM6PR13CA0049.namprd13.prod.outlook.com
 (2603:10b6:5:134::26) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by DM6PR13CA0049.namprd13.prod.outlook.com (2603:10b6:5:134::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.7 via Frontend Transport; Thu, 10 Dec 2020 03:27:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 571c6060-f063-458e-2a1e-08d89cbb779c
X-MS-TrafficTypeDiagnostic: SN6PR12MB4671:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4671E03B4E0C78D428113C8CE5CB0@SN6PR12MB4671.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cYxeAF6I3GldDbyQnkhgTNNeXRMF7VNApGf6GFwv85JU6pjMRK/DBJBkRQUyd9+8QYdCxYfNWwStQlMlr7ORtsJkbTa/5JYw2Oyt5qM38O5yy9Y3GfDH74XKeFImgLtrvpnjFw/eo/yDck/vs4LM0ksmtTheYQ2o/CyOotis9eRvlO84Jq1G+RuElFfrhTlXL/uE0OTr958krN+lnzCQGDCKmglrXc4p4VdN7E91oz0kjCHHdv7Cfae0HkTIod/dJ/cDC/MF8U28gIUgI9meAeS7Gamg99qk3xaKtaDEVUmnxvBZVabeZAS7PjLbClcpOSiYFAWDs4OOfSU2cvofxLB0bQVrkabnU+sixWIvgYq2vjYAHvyFbI+WkePhKnKe62VeHApvEzfVWqvkqxhmjXbg7CnfIKd2Bg/a0lhqSaTi7Z8CFgF+2znxFmlOzMbh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(26005)(956004)(83380400001)(508600001)(31696002)(34490700003)(4326008)(53546011)(6506007)(8936002)(5660300002)(2616005)(52116002)(86362001)(2906002)(54906003)(16526019)(66556008)(6512007)(36756003)(66946007)(186003)(6666004)(8676002)(6916009)(31686004)(66476007)(7416002)(44832011)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OTdyaDRST2dLWUZTUThPZUFlczY0emQ0cFliSlFuQnVIQjVDTmNEdHRRZENy?=
 =?utf-8?B?bXRENXVmV2pmenB0SWVOR09JYUk1Q0JuM2ZEcEk5ejVUR1ppODBja1VnZG94?=
 =?utf-8?B?Y2w5eXVxT2d0RDVMelBoTERnYUhFQmhiZ0lHdFIwUUFRcHhTWXdsYWE4dTYz?=
 =?utf-8?B?RVhHNTlwQW92YjlweFdJaTU1YndHMi9yMFN3Vkc4cDRxUktYTG9RYXNpeGhn?=
 =?utf-8?B?OS9Fbk15UlQ0UGVVRUJUTG1qaktlYmtZaS96YnJEdFhRdjNwMFZDQ0FlRWt2?=
 =?utf-8?B?MHUzWEFodC9aS0FsUHNHMDZoR3dGQnh5U3ltYW5mQm5YbFpXWEFEMUZwb29X?=
 =?utf-8?B?dUIyUGovMTZDR2d6MHVsbDZGdzIvSjBEVENEaWRKNEsxR1RNKzNFUm1za0dO?=
 =?utf-8?B?TCt5K21yVWJYbk42dTdUNXo3U2F2MWFIalMwVm54b2RPRWd0cDhvV0dFNldu?=
 =?utf-8?B?aTRJK1ovNTB2aWVRQjdTU0M4TENRdjU4enJRemVURXdHOWd3blhhbTM3cWNt?=
 =?utf-8?B?ZXByUmwrRGtTS0N6QnF3L0RQMEtsaHFNc21lTDl5Skk1d1ZReGpzN1k0S0pL?=
 =?utf-8?B?enhtSUo5Z3RkWU9ER2lqUFZsVGtHc3ZFQXJqS295RDNScGlySjJjNjJnQ1hJ?=
 =?utf-8?B?OGlJWi85MEJtNHZGRjlLV212bGtMQjNFd1pPYVdPaFBlOVduYjZUeE5CZHFv?=
 =?utf-8?B?ai85WG9teFp2TCtRQW9HUjhENFp5allUdWtDbGVOQVg1MzVYcGovbkRIOEQz?=
 =?utf-8?B?SkhmNlRrTGx0TDdhQ3dwdGtnSG4vTlZEejFzRE5hS1ZJMkJkeG5mejFPQ0dT?=
 =?utf-8?B?STJkMlpxQ3BkY2R6SVY4SFkxRWpFNmNEVjNJTjNJZGd5cjJGMjFLd29WL3A0?=
 =?utf-8?B?M1MwaWxaci9KSTlSWk9pWTJLbmp2clJhZTlJWTdhZGVZamUxQlc4elBaR0h4?=
 =?utf-8?B?UHVVdUFubkdOVkEzWTJiRGEvcVJYVE5ZYUNsNTB1VEhPMWRIVEtRekxuTWJs?=
 =?utf-8?B?L1FaM0ZJbUtxejF6cUpzNWVpMEl4TDB2enYrU0FkbExSYjZQYkFkSXFWZ1BX?=
 =?utf-8?B?bGp2U3dONGFnMmJHZEV0c24xbHlyT2pVbTRTbXNFcENraHBlR0lDN2hncjh2?=
 =?utf-8?B?QjI2Y24zQnV2TjdQekJlcHpDbEVxRGlWNVhhcEtnQjZidzdkZmFTKzMveFlr?=
 =?utf-8?B?OFdpUmFDR1VIdnhLQVhvcWxEYXZJeWJmRzlTelI2WHdPcWgxTTNZMDhRMWlT?=
 =?utf-8?B?TDFPNXk0WXdlTUNEZ3BLWi9uMkYvYXFRdlhrZGE4UDloYTUzN0E2TWVaV3Vw?=
 =?utf-8?Q?nymHjbdZmNp/TCujfZYVEyXPYYxuXc2mG4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 03:27:05.1416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 571c6060-f063-458e-2a1e-08d89cbb779c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /40y7BE2UJUVoZIGKLPmiZcWi0VL+baXS8i9GOl6IeaAtn6VysvUfFgVqR2k60oys0/0fR4K9QzMehKBSeINUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4671
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/9/20 1:51 AM, Ard Biesheuvel wrote:
> On Fri, 4 Dec 2020 at 22:30, Brijesh Singh <brijesh.singh@amd.com> wrote:
>> The SEV FW version >= 0.23 added a new command that can be used to query
>> the attestation report containing the SHA-256 digest of the guest memory
>> encrypted through the KVM_SEV_LAUNCH_UPDATE_{DATA, VMSA} commands and
>> sign the report with the Platform Endorsement Key (PEK).
>>
>> See the SEV FW API spec section 6.8 for more details.
>>
>> Note there already exist a command (KVM_SEV_LAUNCH_MEASURE) that can be
>> used to get the SHA-256 digest. The main difference between the
>> KVM_SEV_LAUNCH_MEASURE and KVM_SEV_ATTESTATION_REPORT is that the later
> latter
>
>> can be called while the guest is running and the measurement value is
>> signed with PEK.
>>
>> Cc: James Bottomley <jejb@linux.ibm.com>
>> Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: John Allen <john.allen@amd.com>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: linux-crypto@vger.kernel.org
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  .../virt/kvm/amd-memory-encryption.rst        | 21 ++++++
>>  arch/x86/kvm/svm/sev.c                        | 71 +++++++++++++++++++
>>  drivers/crypto/ccp/sev-dev.c                  |  1 +
>>  include/linux/psp-sev.h                       | 17 +++++
>>  include/uapi/linux/kvm.h                      |  8 +++
>>  5 files changed, 118 insertions(+)
>>
>> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
>> index 09a8f2a34e39..4c6685d0fddd 100644
>> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
>> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
>> @@ -263,6 +263,27 @@ Returns: 0 on success, -negative on error
>>                  __u32 trans_len;
>>          };
>>
>> +10. KVM_SEV_GET_ATTESATION_REPORT
> KVM_SEV_GET_ATTESTATION_REPORT
>
>> +---------------------------------
>> +
>> +The KVM_SEV_GET_ATTESATION_REPORT command can be used by the hypervisor to query the attestation
> KVM_SEV_GET_ATTESTATION_REPORT


Noted, I will send v2 with these fixed.

