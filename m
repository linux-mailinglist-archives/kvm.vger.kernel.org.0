Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA5245DD55
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 16:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237695AbhKYP05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 10:26:57 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:46297 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348746AbhKYPY4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Nov 2021 10:24:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1637853703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oo9EHqlwe5tx2A8UcEyjObWAYtpybcZPt09LjmJEIx8=;
        b=NJJLgvbFIbGSLVeJhEWRsej1YEWpj+eD1Rl8T+RRQ2FHeb9AoGRieLDFeDRmoJ8G+EEOzK
        nEj8ERLG4gjU2w9zJmObY1Rlhtv5zup4xJewoxkF0ASQe88vEHKsLUT5rZK2McHk/rRlTA
        It33RNtb58IIjKHpWghrJvdwcWyoe30=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2055.outbound.protection.outlook.com [104.47.14.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-24-GiB8u7UHOZ6kJF3m1GAnTw-1; Thu, 25 Nov 2021 16:21:42 +0100
X-MC-Unique: GiB8u7UHOZ6kJF3m1GAnTw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lj6p92KCBhzhrB+mqdzWHB+1dgN0yujgqHuzpsEjeemkvyFr47RO7ZSe9HhRv63IHBkdzJogLtl7sVoxeBl74PzMtWl1l3KZLA4QZOS7MehAyQO0CpGdyLs9uOqmPeJcNO4MjDxSOlNFSQsXgTYESxKi0ByFpRSbvVc2w41L2mlxU04Dgbrd4uJjHRScYZE1XVcB5A2J8aQATNKnbf6YAFRtimJkb2JLLmPdWZFcitwiH65PrcXkAZZJPS9IA6kq74R/ywl2urNU7UHe2JZxlNfwzkF4deP/96NDxle0zayJxvk9iAMi+7KNDbN1quCHoa9OjjEkoLkanaBA4EQn5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CVzL8VWX+vHIHQFvOBK7YaRz5f55F3mg4LHDqEWJrRA=;
 b=eicdM2sKejQCGjOKT/3Lq0XYlPyw0utCzAReU7VzBOdnKEdhgXv3RlrRF4OPlYeABAEp2BYA6UvRR4DOoUqgrGmdFzd12gJoDUWejseiCfxdZThO5/Y4+h4oJET5nvHoq9I2GuKy8XhXD6TR8CLSoKRTr77mzHFIVk75uIogxusRL8Df+cKuFmW6SeWs4oL8TsM7NxNFKEeLMT+KvjSw3ZAlLu2bP3G34gFPK5UTdPC0m+HVc6rFy8NeAC6u6oFSATLj1E9+FIK6LlzRJpUKxa+eupue2+TAA1YuCv7BhklqwW4l7QCM3w6LCLNd5ZBFVvE2SVeVBaX+YVamneBREA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM0PR04MB5651.eurprd04.prod.outlook.com (2603:10a6:208:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.19; Thu, 25 Nov
 2021 15:21:40 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::80b4:c12e:2fb5:8b30]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::80b4:c12e:2fb5:8b30%3]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 15:21:40 +0000
Subject: Re: [kvm-unit-tests PATCH v3 00/17] x86_64 UEFI and AMD SEV/SEV-ES
 support
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>, kvm@vger.kernel.org,
        drjones@redhat.com
CC:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com, jroedel@suse.de,
        bp@suse.de
References: <20211004204931.1537823-1-zxwang42@gmail.com>
 <4d3b7ca8-2484-e45c-9551-c4f67fc88da6@redhat.com>
From:   Varad Gautam <varad.gautam@suse.com>
Message-ID: <81f95dad-b1e3-edfb-685f-8dafc92cd5db@suse.com>
Date:   Thu, 25 Nov 2021 16:21:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <4d3b7ca8-2484-e45c-9551-c4f67fc88da6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM6P194CA0043.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::20) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
Received: from [IPv6:2401:4900:1a5f:c881:37c4:21b1:e894:b7fd] (2401:4900:1a5f:c881:37c4:21b1:e894:b7fd) by AM6P194CA0043.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:84::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 15:21:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f90f97f9-00e2-4a88-8f76-08d9b0274780
X-MS-TrafficTypeDiagnostic: AM0PR04MB5651:
X-Microsoft-Antispam-PRVS: <AM0PR04MB56511983E87BD8FF3ED9BE45E0629@AM0PR04MB5651.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g+ljaW0IjWsBaRm7LgnrkJYyxIcCraE6xiuwKfoQe2BiD/cnn5OMVbGYTYlVf8rulWc2H6mpK1i2qw12B/1M1qCJ360kzCwtYOdx1npUzRYhb/IJefTbn7LkionRYE+7cBp5Ok/jrPtzbfYL5F4TOXAt4Pl6fL9uU/P0ifKaNZ0x7C5wPtPSy4khG+BiZXS58MTUjoBA1lR6MlBt8QJzYxKJ1+kSljPanGAAWJFkVCP8EQtPCASTII33zK9xiQT6OFFH9oLciQwVBckE9RQcqSCXETIPjxniP23qQZFo8xNi3dv5ShB/yyCFFUhTl2Ld1mt7YGDaHklgIIhvCqcA33Jq1gEWfG9bwJLDTtGlL4flgysweNlAoT9Kg7DBPVhyp4QBV4pbkhfkwkBqq7BRl/NNdnc0XlmfzMczHnKjxF8OzhAWZ2YoqRG+Mu2wfIyDw4JWYVtLG0PEYM6hLuADF+xyA+NlPnJ0H1Vr7M8JUg8ezkGZ+0pKWx2Z8zDXQZNyzPsr5b5dwQa3lr8TQmBWyNlJbfL+ry+/k7w5Vt5KKP77n5pvqtHyADzStcyqWq0Xno8CDEC/+xTvatzRYC9BfmG3ujz0FLPXQXZLfnR7uKl07lWK6lsx/5qpY6hi8umPW21ARGMnQwi3sBrghINvK3k/5B7J62n99vS6ghJzn37sh1Vwa3i7YbPzVZaJCAJHBSPplrHya2yalUY/OfbnHucVdl5TVHddg8VBqj0+QQV7W4kLBPvBsSIbaKNMXnqbfZBgUC1e42luYE7nSuVP7jDgJdeLUL7IKVU6T98/DNn9FNsc0kiqgALx9m56rircefMHahUJofjLD6hOysNwsvjTNgvUBAs3EVk4Q09+r29PoAO+bjoZqxp+gDK6D0UO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(6486002)(316002)(5660300002)(110136005)(83380400001)(66556008)(66476007)(53546011)(86362001)(6666004)(7416002)(508600001)(31686004)(31696002)(186003)(2616005)(8936002)(36756003)(966005)(4326008)(2906002)(8676002)(44832011)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xadyXuBACjp+a1YwjRIhMixKNcMYwxiAVBlOOhaA1jLoT8JWW6xJmXjJkaAY?=
 =?us-ascii?Q?4x2WdYYOtb1HNw50ueJnXOJR9sAw7kg3m4kluXC4eSHhGj9aC06Tbe/hJIgf?=
 =?us-ascii?Q?zeT2OX0Kqf4gH/BPcWsXZcZ384OzIGC3vfLgmE3MloqT1Dl7F2dT9TB/sBG3?=
 =?us-ascii?Q?NrrFLK5QTbgfKGDfhwCX8+wv5jAPXwcz9BFdi0VrGjja28zLyuJ1nPvtkntv?=
 =?us-ascii?Q?HPUNoeZKziVWDY5w1sBP3rylEVeYNI+ZK0pMpOLddu8pwkgIa/osjeOCJzQC?=
 =?us-ascii?Q?W0fDHHQlq0z7iDmKxkqa9Kcf7bTQ6sHH0nE6hIzGQl1FVpGPRfMtxk1y0/SV?=
 =?us-ascii?Q?f5JmYeIXYc9PiDZc5j215LtzpjXWs2mbNLiYgzBUvEWnowbUk/+7n63KvP7T?=
 =?us-ascii?Q?utGSke2Iaa/LyOloEI7xmDsUCNIFbtZSz073XYaTzVfz5NoujBk33K9PA+Ba?=
 =?us-ascii?Q?P0eYKZXlo5pi2pSpMlVlOvsiGa/DcjQ4lnkmHy8IIWjvdNnjZbsez9IaUmdA?=
 =?us-ascii?Q?o0igtrJDKqXySx69BockRReFtijjBLbFtLBhvu0iFAbRZwhyT1hMvW1IR2Sx?=
 =?us-ascii?Q?79trepBImFq/pLHzsZyS9eU97TCylIsMA75rsqoiff6NUBLVwKL8VCC7Xb0i?=
 =?us-ascii?Q?aaDgLsUXwGbC10d1TP5Yicb4/jb+tCEKDHUnWxzpJYRgqZaxGrkTUWN/dr2K?=
 =?us-ascii?Q?DJbxXuUhBG28rj2CuYfWCJfAHG7YOG0ChiXvkw+bA8ZhvTqn6VTQVKIOFskz?=
 =?us-ascii?Q?On952WKqUaroIG1ONzJ/xeibEYqhpjMyJl8HrN+oaoABis4PEfuQcIYtlpHi?=
 =?us-ascii?Q?8ApaeWKNjBJJ99kJ+saL+7m/c5FcRVBBgqU8oo9t/o1mk7BkPjImXvYRNi/r?=
 =?us-ascii?Q?NOeAehsYUnlZ4FxldpunE82yhb6lITkON5rcXHC/nNY1dKNT+YPHJzuL6km8?=
 =?us-ascii?Q?KuWwG8IhDI4nmMzmImaA9fOUSvV2V0L5rJ2jT6pDjw20PlzguFHyDjYk4U3n?=
 =?us-ascii?Q?ab87FbqGmtB+DRZ1UfTxcwNVi9hPmRKK6EPHFwZO3gcQqpQqaW9B9twEqvDL?=
 =?us-ascii?Q?KInju4CyjmUchjB+yAfwejnHNa8GXXXSHCul2tcLz65NLbX8QKRdrhf/gqT5?=
 =?us-ascii?Q?F2Ob+FA6xF16Wrs30oDfpARF7GtnQxQqQjhuncQcqzWJblfsEXQgpM/NTjoi?=
 =?us-ascii?Q?JSlg5moj5qJOPXePbcSSmGE446zFCCBHeXpMkPvBNsj25qoCexsGGCvoLXU2?=
 =?us-ascii?Q?xr0wuowHdjXZhQsj1U/rsq2WVjGtzRceYHT2NxRhBtvHYQSOHBNnoFT3IyvX?=
 =?us-ascii?Q?YRVNzglyWFVlICEMDoY2eHTk10ldRke7ak1Jl8bmXH7DKmfygXmeOTFknqDE?=
 =?us-ascii?Q?4Jg5nc+pEoPwKnZcMbuUioWQbQv0gItdPLEKVnCRpEE6DY2EXi4JkEJOo0+r?=
 =?us-ascii?Q?dXSfgTVaYZmFS6RQkWYef4bA+pejRNQvpM93J/gKeVJu8F8oTDcoC3p++Xey?=
 =?us-ascii?Q?qR7SJ4IKvHAyYCpIA42FCRuEajzjPonULTKtu5fltM3Rn8rODsiFAjgJrjY6?=
 =?us-ascii?Q?U6ZNGk2Vjgu7AjHFKPNpvC7QseGfQr20WFohDS3R1UtF4GD14d2E83hLkBlJ?=
 =?us-ascii?Q?ibg9qr3lpNO1qFplqiwdY4pFSWgGqI/3o3FzSp+LEmtUjgtLS99mhJXrJhK+?=
 =?us-ascii?Q?guLC8Wv7CI1FmYatjIoZfD2IRLI=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f90f97f9-00e2-4a88-8f76-08d9b0274780
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 15:21:40.1385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xzx6idAKnVYHViNrQyRHrhwzsKk6nMkQqplHhO+b9uCQFl2NUisvjtyKbBpOzYpUGcpssrL8bKbgA0nZEH6zHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5651
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/21/21 4:10 PM, Paolo Bonzini wrote:
> On 04/10/21 22:49, Zixuan Wang wrote:
>> Hello,
>=20
> WHOA IT WORKS! XD
>=20
> There are still a few rough edges around the build system (and in general=
, the test harness is starting to really show its limits), but this is awes=
ome work.=C2=A0 Thanks Drew, Varad and Zixuan (in alphabetic and temporal o=
rder) for the combined contribution!
>=20
> For now I've placed it at a 'uefi' branch on gitlab, while I'm waiting fo=
r some reviews of my GDT cleanup work.=C2=A0 Any future improvements can be=
 done on top.
>=20

While doing the #VC handler support for test binaries [1], I realised I can=
't seem
to run any of the tests from the uefi branch [2] that write to cr3 via setu=
p_vm()
on SEV-ES. These tests (eg., tscdeadline_latency) crash with SEV-ES, and wo=
rk with
uefi without SEV-ES (policy=3D0x0). I'm wondering if I am missing something=
, is
setup_vm->setup_mmu->write_cr3() known to work on SEV-ES elsewhere?

[1] https://lore.kernel.org/all/20211117134752.32662-1-varad.gautam@suse.co=
m/
[2] https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/tree/uefi

Thanks,
Varad

> Paolo
>=20
>> This patch series updates the x86_64 KVM-Unit-Tests to run under UEFI
>> and culminates in enabling AMD SEV/SEV-ES. The patches are organized as
>> four parts.
>>
>> The first part (patch 1) refactors the current Multiboot start-up code
>> by converting assembly data structures into C. This enables the
>> follow-up UEFI patches to reuse these data structures without redefining
>> or duplicating them in assembly.
>>
>> The second part (patches 2-3) copies code from Varad's patch set [1]
>> that builds EFI stubs without depending on GNU-EFI. Part 3 and 4 are
>> built on top of this part.
>>
>> The third part (patches 4-11) enables the x86_64 test cases to run
>> under UEFI. In particular, these patches allow the x86_64 test cases to
>> be built as EFI executables and take full control of the guest VM. The
>> efi_main() function sets up the KVM-Unit-Tests framework to run under
>> UEFI and then launches the test cases' main() functions. To date, we
>> have 38/43 test cases running with UEFI using this approach.
>>
>> The fourth part of the series (patches 12-17) focuses on SEV. In
>> particular, these patches introduce SEV/SEV-ES set up code into the EFI
>> set up process, including checking if SEV is supported, setting c-bits
>> for page table entries, and (notably) reusing the UEFI #VC handler so
>> that the set up process does not need to re-implement it (a test case
>> can always implement a new #VC handler and load it after set up is
>> finished). Using this approach, we are able to launch the x86_64 test
>> cases under SEV-ES and exercise KVM's VMGEXIT handler.
>>
>> Note, a previous feedback [3] indicated that long-term we'd like to
>> instrument KVM-Unit-Tests with it's own #VC handler. However, we still
>> believe that the current approach is good as an intermediate solution,
>> because it unlocks a lot of testing and we do not expect that testing
>> to be inherently tied to the UEFI's #VC handler. Rather, test cases
>> should be tied to the underlying GHCB spec implemented by an
>> arbitrary #VC handler.
>>
>> See the Part 1 to Part 4 summaries, below, for a high-level breakdown
>> of how the patches are organized.
>>
>> Part 1 Summary:
>> Commit 1 refactors boot-related data structures from assembly to C.
>>
>> Part 2 Summary:
>> Commits 2-3 copy code from Varad's patch set [1] that implements
>> EFI-related helper functions to replace the GNU-EFI library.
>>
>> Part 3 Summary:
>> Commits 4-5 introduce support to build test cases with EFI support.
>>
>> Commits 6-10 set up KVM-Unit-Tests to run under UEFI. In doing so, these
>> patches incrementally enable most existing x86_64 test cases to run
>> under UEFI.
>>
>> Commit 11 fixes several test cases that fail to compile with EFI due
>> to UEFI's position independent code (PIC) requirement.
>>
>> Part 4 Summary:
>> Commits 12-13 introduce support for SEV by adding code to set the SEV
>> c-bit in page table entries.
>>
>> Commits 14-16 introduce support for SEV-ES by reusing the UEFI #VC
>> handler in KVM-Unit-Tests. They also fix GDT and IDT issues that occur
>> when reusing UEFI functions in KVM-Unit-Tests.
>>
>> Commit 17 adds additional test cases for SEV-ES.
>>
>> Changes V2 -> V3:
>> V3 Patch #=C2=A0 Changes
>> ----------=C2=A0 -------
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 01/17=C2=A0 (New patch) refactors assembl=
y data structures in C
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 02/17=C2=A0 Adds a missing alignment attr=
ibute
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 Renames the file uefi.h to efi.h
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 03/17=C2=A0 Adds an SPDX header, fixes a =
comment style issue
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 06/17=C2=A0 Removes assembly data structu=
re definitions
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 07/17=C2=A0 Removes assembly data structu=
re definitions
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 12/17=C2=A0 Simplifies an if condition co=
de
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 14/17=C2=A0 Simplifies an if condition co=
de
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 15/17=C2=A0 Removes GDT copying for SEV-E=
S #VC handler
>>
>> Notes on page table set up code:
>> Paolo suggested unifying=C2=A0 the page table definitions in cstart64.S =
and
>> UEFI start-up code [5]. We tried but found it hard to implement due to
>> the real/long mode issue: a page table set up function written in C is
>> by default compiled to run in long mode. However, cstart64.S requires
>> page table setup before entering long mode. Calling a long mode function
>> from real/protected mode crashes the guest VM. Thus we chose not to
>> implement this feature in this patch set. More details can be found in
>> our off-list GitHub review [6].
>>
>> Changes V1 -> V2:
>> 1. Merge Varad's patches [1] as the foundation of our V2 patch set [4].
>> 2. Remove AMD SEV/SEV-ES config flags and macros (patches 11-17)
>> 3. Drop one commit 'x86 UEFI: Move setjmp.h out of desc.h' because we do
>> not link GNU-EFI library.
>>
>> Notes on authorships and attributions:
>> The first two commits are from Varad's patch set [1], so they are
>> tagged as 'From:' and 'Signed-off-by:' Varad. Commits 3-7 are from our
>> V1 patch set [2], and since Varad implemented similar code [1], these
>> commits are tagged as 'Co-developed-by:' and 'Signed-off-by:' Varad.
>>
>> Notes on patch sets merging strategy:
>> We understand that the current merging strategy (reorganizing and
>> squeezing Varad's patches into two) reduces Varad's authorships, and we
>> hope the additional attribution tags make up for it. We see another
>> approach which is to build our patch set on top of Varad's original
>> patch set, but this creates some noise in the final patch set, e.g.,
>> x86/cstart64.S is modified in Varad's part and later reverted in our
>> part as we implement start up code in C. For the sake of the clarity of
>> the code history, we believe the current approach is the best effort so
>> far, and we are open to all kinds of opinions.
>>
>> [1] https://lore.kernel.org/kvm/20210819113400.26516-1-varad.gautam@suse=
.com/
>> [2] https://lore.kernel.org/kvm/20210818000905.1111226-1-zixuanwang@goog=
le.com/
>> [3] https://lore.kernel.org/kvm/YSA%2FsYhGgMU72tn+@google.com/
>> [4] https://lore.kernel.org/kvm/20210827031222.2778522-1-zixuanwang@goog=
le.com/
>> [5] https://lore.kernel.org/kvm/3fd467ae-63c9-adba-9d29-09b8a7beb92d@red=
hat.com/
>> [6] https://github.com/marc-orr/KVM-Unit-Tests-dev-fork/pull/1
>>
>> Regards,
>> Zixuan Wang
>>
>> Varad Gautam (2):
>> =C2=A0=C2=A0 x86 UEFI: Copy code from Linux
>> =C2=A0=C2=A0 x86 UEFI: Implement UEFI function calls
>>
>> Zixuan Wang (15):
>> =C2=A0=C2=A0 x86: Move IDT, GDT and TSS to desc.c
>> =C2=A0=C2=A0 x86 UEFI: Copy code from GNU-EFI
>> =C2=A0=C2=A0 x86 UEFI: Boot from UEFI
>> =C2=A0=C2=A0 x86 UEFI: Load IDT after UEFI boot up
>> =C2=A0=C2=A0 x86 UEFI: Load GDT and TSS after UEFI boot up
>> =C2=A0=C2=A0 x86 UEFI: Set up memory allocator
>> =C2=A0=C2=A0 x86 UEFI: Set up RSDP after UEFI boot up
>> =C2=A0=C2=A0 x86 UEFI: Set up page tables
>> =C2=A0=C2=A0 x86 UEFI: Convert x86 test cases to PIC
>> =C2=A0=C2=A0 x86 AMD SEV: Initial support
>> =C2=A0=C2=A0 x86 AMD SEV: Page table with c-bit
>> =C2=A0=C2=A0 x86 AMD SEV-ES: Check SEV-ES status
>> =C2=A0=C2=A0 x86 AMD SEV-ES: Copy UEFI #VC IDT entry
>> =C2=A0=C2=A0 x86 AMD SEV-ES: Set up GHCB page
>> =C2=A0=C2=A0 x86 AMD SEV-ES: Add test cases
>>
>> =C2=A0 .gitignore=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 3 +
>> =C2=A0 Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 29 +-
>> =C2=A0 README.md=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 6 +
>> =C2=A0 configure=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 6 +
>> =C2=A0 lib/efi.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 118 ++++++++
>> =C2=A0 lib/efi.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 22 ++
>> =C2=A0 lib/linux/efi.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 539 +++++++++++++++++++++++++++++++++++++
>> =C2=A0 lib/x86/acpi.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 38 ++-
>> =C2=A0 lib/x86/acpi.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 11 +
>> =C2=A0 lib/x86/amd_sev.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 174 ++++++++++++
>> =C2=A0 lib/x86/amd_sev.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 63 +++++
>> =C2=A0 lib/x86/asm/page.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0 28 +-
>> =C2=A0 lib/x86/asm/setup.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 35 +++
>> =C2=A0 lib/x86/desc.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 46 +++-
>> =C2=A0 lib/x86/desc.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 6 +-
>> =C2=A0 lib/x86/setup.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 246 +++++++++++++++++
>> =C2=A0 lib/x86/usermode.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 3 +-
>> =C2=A0 lib/x86/vm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 18 +-
>> =C2=A0 x86/Makefile.common=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 68 +++--
>> =C2=A0 x86/Makefile.i386=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0=C2=A0 5 +-
>> =C2=A0 x86/Makefile.x86_64=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 58 ++--
>> =C2=A0 x86/access.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 9 +-
>> =C2=A0 x86/amd_sev.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 94 +++++++
>> =C2=A0 x86/cet.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 8 +-
>> =C2=A0 x86/cstart64.S=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 77 +-----
>> =C2=A0 x86/efi/README.md=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 63 +++++
>> =C2=A0 x86/efi/crt0-efi-x86_64.S=C2=A0 |=C2=A0 79 ++++++
>> =C2=A0 x86/efi/efistart64.S=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 =
77 ++++++
>> =C2=A0 x86/efi/elf_x86_64_efi.lds |=C2=A0 81 ++++++
>> =C2=A0 x86/efi/reloc_x86_64.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 96 +++++++
>> =C2=A0 x86/efi/run=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 63 +++++
>> =C2=A0 x86/emulator.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 5 +-
>> =C2=A0 x86/eventinj.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 6 +-
>> =C2=A0 x86/run=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 16 +-
>> =C2=A0 x86/smap.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 8 +-
>> =C2=A0 x86/umip.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 10 +-
>> =C2=A0 x86/vmx.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 8 +-
>> =C2=A0 37 files changed, 2067 insertions(+), 155 deletions(-)
>> =C2=A0 create mode 100644 lib/efi.c
>> =C2=A0 create mode 100644 lib/efi.h
>> =C2=A0 create mode 100644 lib/linux/efi.h
>> =C2=A0 create mode 100644 lib/x86/amd_sev.c
>> =C2=A0 create mode 100644 lib/x86/amd_sev.h
>> =C2=A0 create mode 100644 lib/x86/asm/setup.h
>> =C2=A0 create mode 100644 x86/amd_sev.c
>> =C2=A0 create mode 100644 x86/efi/README.md
>> =C2=A0 create mode 100644 x86/efi/crt0-efi-x86_64.S
>> =C2=A0 create mode 100644 x86/efi/efistart64.S
>> =C2=A0 create mode 100644 x86/efi/elf_x86_64_efi.lds
>> =C2=A0 create mode 100644 x86/efi/reloc_x86_64.c
>> =C2=A0 create mode 100755 x86/efi/run
>>
>=20

