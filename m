Return-Path: <kvm+bounces-69017-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SKBANsXEc2kpygAAu9opvQ
	(envelope-from <kvm+bounces-69017-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 19:58:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D2A079E8D
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 19:58:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 425D03040443
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 18:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4F6029B8E5;
	Fri, 23 Jan 2026 18:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KAPdDucs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB0B27B4FA
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 18:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769194675; cv=pass; b=M7Bth0rKkLdhxwlJguEj1PlulSodTFK7IxNiaT1h7MAJsKulAJPsNWLY55SP0iTnlNfBNYoC5S4gA3LWhui2Mo72V/U/E8ZjY7MiFoIpdPvVR24lcum4ycz22Kqp9I/7VM0BzyAEAnMn6LRUQNXyI/k0JVcQKaN7mwkX0VohLlI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769194675; c=relaxed/simple;
	bh=eDapWr+n9P1X1BHF5iSqs6NkiN+CqMz7juT17mz9KkY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YrSNNiiS9pTAwjqbJb0B3khwkvVIzXOxvVipYwDcqTp9Wpr1PY3+7P4Jf5YAx4dVfHCnoq9Ga8Q25VhkzGf13ODD9J8Oins6KFM3WcZ/89AtyvD86auFhIqHNZJWOzZLPQVHRfHwWb+d3i2PyCgnzcbN+eBB0iEfeo1Bilg6nfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KAPdDucs; arc=pass smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-5ed065f1007so1857387137.1
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 10:57:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769194672; cv=none;
        d=google.com; s=arc-20240605;
        b=YuNWmVD3d/xxW3mxKFmVbyAPniWx0Tg5u/uYWfaSKtXPmSYaVHQGNPxyhoYMorOEP3
         FV6GaAkutr+c03ItutOxvL9/qoSR7v31cn3sE0K101b6gHuV6he28tTDaBKxNouVoDy7
         jTVdPPn8Zfq40Vw3Wj3h9eYvQOwWhC/e5pML5jt0WobfBJwxFoqnO/0nVOQq4SaqQK2R
         fy7FfEI3GGPte7KqSNmdTl1kNM0Eucpwgqpn2fKc2dnt7sEk/idu81Rc4fIm1aDHZs6S
         wUuNpyK/OF4AoPqkbVylRsgDWB9eEX18yZIKXUKm6xO7n5jiQsEbdibxlc7k7h2rzyCR
         BXqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZS1VP6COkKjKYZmCvco4g4510UVwVXjW35gfix/QdJA=;
        fh=t4wjTIcRo2x/La+yqZ14sHjG2lTsq49eV6sOT6MXGd4=;
        b=ZL7aqr1tp4cEEVPiwydD9M3ssBjSwHtKLqCusZQjTo+PyNEPOe8OuGZS8YjImwV4AE
         O6Grwnnk3HmCS9EXW6wygmI7xOd9iOD/EkfDjk2YhakFuTcsdvlY9xltIULCilBz9o9g
         P9ZMTU7o8neAqezN2dZ5d9dUeHOZ2AzLDY1vrDsdRsqi+zPDEi8n2TGV/bCt75DF2DjV
         B1yseUuGqaUlUfFttdC+1t/Hs4Vr0F6C99ctmmS8WF7tnjF0ak10bA6fzgAZr+ExcPeY
         vce4Uf3qK1kZWXGBBrmqDo8I0YmE4dB6w4HtzAUiMVfKr2J5eV978cnPussTrs8x0/rZ
         bZwA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769194672; x=1769799472; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZS1VP6COkKjKYZmCvco4g4510UVwVXjW35gfix/QdJA=;
        b=KAPdDucsbgGJ+HuxzC0nJK32iWlZSMxdGWPov3HvSczwVBS4kkStSzwWNdqPQIFInb
         Mbad1IxrxFy0nRMgQDrc6ZVj4rZCCOvjfAe0w3uXALM9LPrB3roaGPVRLukcf707CXjO
         aJuPuww7WvkubRSXAkVq3K2C82268CSM6Ihi+pG2sKp6P+wh98N3asgs0d/N4U/0phap
         6M4Nt2IK+q3e4BO4FjQqF0rxmv2vWsGhKRMexBDs24ZkhB0zysyh80LkO0ENPWQsOoP9
         ASpvnNN7iVDxqdV4qNrSmJQlH6N7xRf2a9RgEXvKH3GoIFniR92CtvR1PzwgXJtuFpR3
         Jx3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769194672; x=1769799472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZS1VP6COkKjKYZmCvco4g4510UVwVXjW35gfix/QdJA=;
        b=N7Pd1eGtEZZCn8aizQe0XCJBZVAdeQDT8cnd0BniPRcu2SRHPkdC3qKpR+T0wHXVsq
         l2OA0i3gtQX8KDajhahXei4OLl57+Quly877gENghbwqcIwGhf3RrXn+wdBn5CdpnWID
         /Gik11Ma7Jn4BohdXnmI7Vl9ytrQdEmgsApPpDPUglXqLro6D0rTlcXeD2KZCCzW4HoZ
         jn7pUcsoXnUQJUhPRavogXe/ibOjoroHGYMHg7PrB3TE3T5ZdallmuUBU1XxCoNSA1QX
         97A0sCuhj8StVlSBFt9XPdWi4JiF8Tp5+02VS5JHqX7Hs4WpyIoLFGMFp203X9EU7QW1
         artw==
X-Gm-Message-State: AOJu0YxcF8WE1hBaJ5Ua2CJpq8lqQUreR7nYuhSUesmIs/SS4jPWw/Xp
	KddjeAO+KQWKq04Vg0/dmc7xcFeke3kQShbZsfptNOrt2Ch8Xxw7rhh7LQO0QS2eXyXiGTcP/ks
	7Nt5cRX7e8sWrDtbwJU+ewM7QspsdUgPx3QKAr049
X-Gm-Gg: AZuq6aKvQDoJ46Z3vfCFsqwIv0qTGBWuDXHYh5q1r8jBxt/N9Wp3+rL7KEgijR81EAm
	vyGFSUSpvX+VQJUtDYfrLghVFUsU4UnaJ3qfE9u7npB6qG4VJz0dokL7cedGHHQPmT/hhrspK5k
	EcvrS33bFxGjfSmOZLpyoDfHgHkHNZOwvwVXEm/zeedo3qUbM/aq6r6UxIxQ9icM8MkJU5zSefV
	Gb0gkx2qeuRMpn01Ma6sfdUqP1dhMCuxZnYmWSJxci/jIwkwimYA3PhNhnAwDJCYxJ6qGKhH4ps
	ZhdSW512L8KbjYv7l9+jNJwzNg==
X-Received: by 2002:a05:6102:dd1:b0:5ef:2457:8011 with SMTP id
 ada2fe7eead31-5f54bc628a1mr1369126137.21.1769194671879; Fri, 23 Jan 2026
 10:57:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251217101125.91098-1-steven.price@arm.com> <20251217101125.91098-23-steven.price@arm.com>
In-Reply-To: <20251217101125.91098-23-steven.price@arm.com>
From: Alper Gun <alpergun@google.com>
Date: Fri, 23 Jan 2026 10:57:38 -0800
X-Gm-Features: AZwV_QhZYPGr8z6s2H9r2lNS2DnUjwnSFq4bTCqpFEvFz2mvBWHpQWX_DZm5pNo
Message-ID: <CABpDEumQ=62nZ_xEN6oMHw=J+6ps=Gy=1vx8i=6Hz+BacO1Ymg@mail.gmail.com>
Subject: Re: [PATCH v12 22/46] arm64: RMI: Create the realm descriptor
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, 
	Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69017-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alpergun@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5D2A079E8D
X-Rspamd-Action: no action

On Wed, Dec 17, 2025 at 2:13=E2=80=AFAM Steven Price <steven.price@arm.com>=
 wrote:
>
> Creating a realm involves first creating a realm descriptor (RD). This
> involves passing the configuration information to the RMM. Do this as
> part of realm_ensure_created() so that the realm is created when it is
> first needed.
>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> New patch for v12
> ---
>  arch/arm64/kvm/rmi.c | 117 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 115 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index b51e68e56d56..18edc7eeb5fa 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -500,6 +500,106 @@ static void realm_unmap_shared_range(struct kvm *kv=
m,
>                              start, end);
>  }
>
> +/* Calculate the number of s2 root rtts needed */
> +static int realm_num_root_rtts(struct realm *realm)
> +{
> +       unsigned int ipa_bits =3D realm->ia_bits;
> +       unsigned int levels =3D 4 - get_start_level(realm);
> +       unsigned int sl_ipa_bits =3D levels * (RMM_PAGE_SHIFT - 3) +
> +                                  RMM_PAGE_SHIFT;
> +
> +       if (sl_ipa_bits >=3D ipa_bits)
> +               return 1;
> +
> +       return 1 << (ipa_bits - sl_ipa_bits);
> +}
> +
> +static int realm_create_rd(struct kvm *kvm)
> +{
> +       struct realm *realm =3D &kvm->arch.realm;
> +       struct realm_params *params =3D realm->params;
> +       void *rd =3D NULL;
> +       phys_addr_t rd_phys, params_phys;
> +       size_t pgd_size =3D kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtc=
r);
> +       int i, r;
> +       int rtt_num_start;
> +
> +       realm->ia_bits =3D VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
> +       rtt_num_start =3D realm_num_root_rtts(realm);
> +
> +       if (WARN_ON(realm->rd || !realm->params))
> +               return -EEXIST;
> +
> +       if (pgd_size / RMM_PAGE_SIZE < rtt_num_start)
> +               return -EINVAL;
> +
> +       rd =3D (void *)__get_free_page(GFP_KERNEL);
> +       if (!rd)
> +               return -ENOMEM;
> +
> +       rd_phys =3D virt_to_phys(rd);
> +       if (rmi_granule_delegate(rd_phys)) {
> +               r =3D -ENXIO;
> +               goto free_rd;
> +       }
> +
> +       for (i =3D 0; i < pgd_size; i +=3D RMM_PAGE_SIZE) {
> +               phys_addr_t pgd_phys =3D kvm->arch.mmu.pgd_phys + i;
> +
> +               if (rmi_granule_delegate(pgd_phys)) {
> +                       r =3D -ENXIO;
> +                       goto out_undelegate_tables;
> +               }
> +       }
> +
> +       params->s2sz =3D VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
> +       params->rtt_level_start =3D get_start_level(realm);
> +       params->rtt_num_start =3D rtt_num_start;
> +       params->rtt_base =3D kvm->arch.mmu.pgd_phys;
> +       params->vmid =3D realm->vmid;

I don't see a way to configure rpv and hash_algo anymore. I assume they
are gone for a minimal userspace interface. Will there be a way to set
them going forward?

> +
> +       params_phys =3D virt_to_phys(params);
> +
> +       if (rmi_realm_create(rd_phys, params_phys)) {
> +               r =3D -ENXIO;
> +               goto out_undelegate_tables;
> +       }
> +
> +       if (WARN_ON(rmi_rec_aux_count(rd_phys, &realm->num_aux))) {
> +               WARN_ON(rmi_realm_destroy(rd_phys));
> +               r =3D -ENXIO;
> +               goto out_undelegate_tables;
> +       }
> +
> +       realm->rd =3D rd;
> +       WRITE_ONCE(realm->state, REALM_STATE_NEW);
> +       /* The realm is up, free the parameters.  */
> +       free_page((unsigned long)realm->params);
> +       realm->params =3D NULL;
> +
> +       return 0;
> +
> +out_undelegate_tables:
> +       while (i > 0) {
> +               i -=3D RMM_PAGE_SIZE;
> +
> +               phys_addr_t pgd_phys =3D kvm->arch.mmu.pgd_phys + i;
> +
> +               if (WARN_ON(rmi_granule_undelegate(pgd_phys))) {
> +                       /* Leak the pages if they cannot be returned */
> +                       kvm->arch.mmu.pgt =3D NULL;
> +                       break;
> +               }
> +       }
> +       if (WARN_ON(rmi_granule_undelegate(rd_phys))) {
> +               /* Leak the page if it isn't returned */
> +               return r;
> +       }
> +free_rd:
> +       free_page((unsigned long)rd);
> +       return r;
> +}
> +
>  static int realm_unmap_private_page(struct realm *realm,
>                                     unsigned long ipa,
>                                     unsigned long *next_addr)
> @@ -803,8 +903,21 @@ static int realm_init_ipa_state(struct kvm *kvm,
>
>  static int realm_ensure_created(struct kvm *kvm)
>  {
> -       /* Provided in later patch */
> -       return -ENXIO;
> +       int ret;
> +
> +       switch (kvm_realm_state(kvm)) {
> +       case REALM_STATE_NONE:
> +               break;
> +       case REALM_STATE_NEW:
> +               return 0;
> +       case REALM_STATE_DEAD:
> +               return -ENXIO;
> +       default:
> +               return -EBUSY;
> +       }
> +
> +       ret =3D realm_create_rd(kvm);
> +       return ret;
>  }
>
>  static int set_ripas_of_protected_regions(struct kvm *kvm)
> --
> 2.43.0
>

