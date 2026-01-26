Return-Path: <kvm+bounces-69090-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2EK+HBM6d2mMdQEAu9opvQ
	(envelope-from <kvm+bounces-69090-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:55:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F3AE86440
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:55:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 65D27302F70D
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 09:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67F192F8BC3;
	Mon, 26 Jan 2026 09:51:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 394272F5337;
	Mon, 26 Jan 2026 09:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769421058; cv=none; b=iZUBT99I07nv0GXG7rsgxLq+ACRhvLmw2qEeXHeuunktejrP27lAcsriIc9DH72u7VSwh1jZgP3TeMmG4azWlkrZItHdqYb0Ede/cWSohDvxnk4gzfmhGdvn1LuyKH0BZ8lejnFZsjSlMgf3eQjDe+zbUwomrFWz4gMdhFhsVWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769421058; c=relaxed/simple;
	bh=b+QADDDNWFijtCScvWxdQYJqkyn6qiVV4dokss2M+ak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fypVeufcPJpkdOGdJahNoMYW8lqad8mXDa3EfozC73iMpHV2KopP+JlDryZwGoppsHltX17WGuTNitYvFUXbXxEJHcO9wAWFS2tJh1ANEBp1HHiJ9/VEcZNql5BmUPDMbAqADvflAGDLNjRTgBfTv2YbWGR8GGeCKsQ++doOweM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04EF4339;
	Mon, 26 Jan 2026 01:50:50 -0800 (PST)
Received: from [10.57.8.194] (unknown [10.57.8.194])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8D583F632;
	Mon, 26 Jan 2026 01:50:52 -0800 (PST)
Message-ID: <e051c4bb-7b1c-4823-b81f-e4df5d8b1d9d@arm.com>
Date: Mon, 26 Jan 2026 09:50:50 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 22/46] arm64: RMI: Create the realm descriptor
To: Alper Gun <alpergun@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
References: <20251217101125.91098-1-steven.price@arm.com>
 <20251217101125.91098-23-steven.price@arm.com>
 <CABpDEumQ=62nZ_xEN6oMHw=J+6ps=Gy=1vx8i=6Hz+BacO1Ymg@mail.gmail.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <CABpDEumQ=62nZ_xEN6oMHw=J+6ps=Gy=1vx8i=6Hz+BacO1Ymg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69090-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[steven.price@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:mid,arm.com:email]
X-Rspamd-Queue-Id: 0F3AE86440
X-Rspamd-Action: no action

On 23/01/2026 18:57, Alper Gun wrote:
> On Wed, Dec 17, 2025 at 2:13 AM Steven Price <steven.price@arm.com> wrote:
>>
>> Creating a realm involves first creating a realm descriptor (RD). This
>> involves passing the configuration information to the RMM. Do this as
>> part of realm_ensure_created() so that the realm is created when it is
>> first needed.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> New patch for v12
>> ---
>>  arch/arm64/kvm/rmi.c | 117 ++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 115 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index b51e68e56d56..18edc7eeb5fa 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -500,6 +500,106 @@ static void realm_unmap_shared_range(struct kvm *kvm,
>>                              start, end);
>>  }
>>
>> +/* Calculate the number of s2 root rtts needed */
>> +static int realm_num_root_rtts(struct realm *realm)
>> +{
>> +       unsigned int ipa_bits = realm->ia_bits;
>> +       unsigned int levels = 4 - get_start_level(realm);
>> +       unsigned int sl_ipa_bits = levels * (RMM_PAGE_SHIFT - 3) +
>> +                                  RMM_PAGE_SHIFT;
>> +
>> +       if (sl_ipa_bits >= ipa_bits)
>> +               return 1;
>> +
>> +       return 1 << (ipa_bits - sl_ipa_bits);
>> +}
>> +
>> +static int realm_create_rd(struct kvm *kvm)
>> +{
>> +       struct realm *realm = &kvm->arch.realm;
>> +       struct realm_params *params = realm->params;
>> +       void *rd = NULL;
>> +       phys_addr_t rd_phys, params_phys;
>> +       size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
>> +       int i, r;
>> +       int rtt_num_start;
>> +
>> +       realm->ia_bits = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
>> +       rtt_num_start = realm_num_root_rtts(realm);
>> +
>> +       if (WARN_ON(realm->rd || !realm->params))
>> +               return -EEXIST;
>> +
>> +       if (pgd_size / RMM_PAGE_SIZE < rtt_num_start)
>> +               return -EINVAL;
>> +
>> +       rd = (void *)__get_free_page(GFP_KERNEL);
>> +       if (!rd)
>> +               return -ENOMEM;
>> +
>> +       rd_phys = virt_to_phys(rd);
>> +       if (rmi_granule_delegate(rd_phys)) {
>> +               r = -ENXIO;
>> +               goto free_rd;
>> +       }
>> +
>> +       for (i = 0; i < pgd_size; i += RMM_PAGE_SIZE) {
>> +               phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i;
>> +
>> +               if (rmi_granule_delegate(pgd_phys)) {
>> +                       r = -ENXIO;
>> +                       goto out_undelegate_tables;
>> +               }
>> +       }
>> +
>> +       params->s2sz = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
>> +       params->rtt_level_start = get_start_level(realm);
>> +       params->rtt_num_start = rtt_num_start;
>> +       params->rtt_base = kvm->arch.mmu.pgd_phys;
>> +       params->vmid = realm->vmid;
> 
> I don't see a way to configure rpv and hash_algo anymore. I assume they
> are gone for a minimal userspace interface. Will there be a way to set
> them going forward?

Yes the intention is that the uAPI will be extended in the future to
allow these to be configured. This would be by exposing new capability
flags and allowing the VMM to set the capability. This ensures that a
basic VMM doesn't need to worry about them, but a more featured VMM can
provide support for configuration.

This series is already rather long so I've attempted to drop optional
parts to keep the complexity down while still providing something
"useful" (i.e. can launch a realm guest and there's some meaningful
extra security/attestation over a normal VM). There's loads of extra
features in the spec which will come later.

Thanks,
Steve

>> +
>> +       params_phys = virt_to_phys(params);
>> +
>> +       if (rmi_realm_create(rd_phys, params_phys)) {
>> +               r = -ENXIO;
>> +               goto out_undelegate_tables;
>> +       }
>> +
>> +       if (WARN_ON(rmi_rec_aux_count(rd_phys, &realm->num_aux))) {
>> +               WARN_ON(rmi_realm_destroy(rd_phys));
>> +               r = -ENXIO;
>> +               goto out_undelegate_tables;
>> +       }
>> +
>> +       realm->rd = rd;
>> +       WRITE_ONCE(realm->state, REALM_STATE_NEW);
>> +       /* The realm is up, free the parameters.  */
>> +       free_page((unsigned long)realm->params);
>> +       realm->params = NULL;
>> +
>> +       return 0;
>> +
>> +out_undelegate_tables:
>> +       while (i > 0) {
>> +               i -= RMM_PAGE_SIZE;
>> +
>> +               phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i;
>> +
>> +               if (WARN_ON(rmi_granule_undelegate(pgd_phys))) {
>> +                       /* Leak the pages if they cannot be returned */
>> +                       kvm->arch.mmu.pgt = NULL;
>> +                       break;
>> +               }
>> +       }
>> +       if (WARN_ON(rmi_granule_undelegate(rd_phys))) {
>> +               /* Leak the page if it isn't returned */
>> +               return r;
>> +       }
>> +free_rd:
>> +       free_page((unsigned long)rd);
>> +       return r;
>> +}
>> +
>>  static int realm_unmap_private_page(struct realm *realm,
>>                                     unsigned long ipa,
>>                                     unsigned long *next_addr)
>> @@ -803,8 +903,21 @@ static int realm_init_ipa_state(struct kvm *kvm,
>>
>>  static int realm_ensure_created(struct kvm *kvm)
>>  {
>> -       /* Provided in later patch */
>> -       return -ENXIO;
>> +       int ret;
>> +
>> +       switch (kvm_realm_state(kvm)) {
>> +       case REALM_STATE_NONE:
>> +               break;
>> +       case REALM_STATE_NEW:
>> +               return 0;
>> +       case REALM_STATE_DEAD:
>> +               return -ENXIO;
>> +       default:
>> +               return -EBUSY;
>> +       }
>> +
>> +       ret = realm_create_rd(kvm);
>> +       return ret;
>>  }
>>
>>  static int set_ripas_of_protected_regions(struct kvm *kvm)
>> --
>> 2.43.0
>>


