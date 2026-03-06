Return-Path: <kvm+bounces-73017-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AIUgMhCxqmluVQEAu9opvQ
	(envelope-from <kvm+bounces-73017-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 11:48:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B5C821F1CF
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 11:48:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 08FEE30965B4
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 10:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30AFC37F8B6;
	Fri,  6 Mar 2026 10:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M4qcSrcm";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QBbJFSW7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FA137BE85
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 10:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772793938; cv=pass; b=jvBgOvYPav8+LWQykqrZu8O+9CduSTVkMhi37QRLkX6Icx8aQ7ZeBFOb2AXp/8U6Pq05lE8Fhq0EbHxa7onYeCSDuqV84+KAo3WvDazZf7mGfLyTEeMiyh/RpIGX/5LQ/ECrJFidEsqYfFOs5fzh1QTcFzaJGriGXGlN5U8NDbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772793938; c=relaxed/simple;
	bh=4+ZluKQE3SyqvN+mzK/Yz0W319zNcEqUt5PY18QlPWM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FAN2c5OTH5hZNUaQDDaazrZ5+GxKf4AsPZKufUMpNHx5ClvarY4e8SiT+m7XGp9+8rYOl+AfDKU22+VUG0PZKysG5MJK8ZAV4DD5dPmjPV6ZocWVmGXx3GcQhfPPooM8tsEh9LCkpu7GNhqovLRrG36sFZAgGVcWQGCAjv1IGNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M4qcSrcm; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QBbJFSW7; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772793936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q0gIJNIcAGUOsJZzstkoZ+rj/OkGKwI2OmgQf4MTA+g=;
	b=M4qcSrcmFENRC98d/wOUuy2HQMv7bSCLXxsFJ5JEE1reH2Eqnq7JY2ZtaPYKrRyyb8Z6gY
	uNUqAf0bPTVZYHhf3OIYemdcSb+0oTxMS6RQXrLShdGgPgphQBGynb9ZclWJ6uCgaIQfJ6
	gzf4p8PLzo8CrlhkwcQq279IIRLBDA8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-sMjNsYDyP0eTz6tci47KUA-1; Fri, 06 Mar 2026 05:45:34 -0500
X-MC-Unique: sMjNsYDyP0eTz6tci47KUA-1
X-Mimecast-MFC-AGG-ID: sMjNsYDyP0eTz6tci47KUA_1772793933
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-439ab866bc1so7205517f8f.2
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 02:45:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772793932; cv=none;
        d=google.com; s=arc-20240605;
        b=B0FpcFaMqNvPMbYKZBPtugB7i6gpp7icL9ukD5+PEgEglO+4y7GznkmhSn8nHoopg4
         YDrOA9RXlhx3tWVoTEDlR70Yg6qtV+RXXVb00gykuIWH8+Bnc6OdoHWVShOfBrPA929C
         1JyPHl9DLpk3VtRXM/4U2kz6f3n69a0I1tBP6bagfw2vFSPQhN5h1oY03GTkiek8O80F
         jkQ8v1jJXdgITU477G65cAxDtX8V+MvbhoYGruxiVnzXvOJWFxnAuvYd+j0zlAh/oZPO
         /HlvSdz+1+SpqCVoTxQ1sn9Ksshc5WW0vIMvgaeNxBcTvb10oh37nn8C1AGWt4/olirD
         EQDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=q0gIJNIcAGUOsJZzstkoZ+rj/OkGKwI2OmgQf4MTA+g=;
        fh=mNu58vj4360Zmgjqydrn0SvyVxS+1qrKHzqK/fvVLZs=;
        b=k7zGoABtu83IBSMEYeSxntdAI+ghgLjU8OslLA9Ewv4SRURvHBO1MKIvzk3p45wI7s
         B7h8ZrtvPujT2ciQg4a1M90T8REz5la0zSmwzaX+FONMasH/aLc78Rczwtgiob4olBIU
         032gjMhHmFTXPl/2P3ZR7ZXZWrJwwuK0NSmi8FqAJ1OooaPFGitrlsJCCd7/rxgkRHjB
         CSpCrz3IPmTPNxNpEPExzsP6WHNFhUhTMVmDBA6eOr0sEFFEuPobUy1AxS6BH8Un8YY2
         I/M/lQ7p8gFQjjMpoLRCXopg7xs9tOOnppxTvRmJlWX9hNhJASN6xEhvw89URiFmnUsg
         IUYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772793932; x=1773398732; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=q0gIJNIcAGUOsJZzstkoZ+rj/OkGKwI2OmgQf4MTA+g=;
        b=QBbJFSW703Qp3/hFbXBMwIyLrhBVZR/8RV2/RWds/T0fh8+Xx7DtqRLN/ZR/vdZ0IU
         IxD8WKoCHWljnHF9rn7VoBo+9TOPa+8nIRBL2Ly7bFHtnqrV7646/Cr6PMHlVqKKgzWD
         65+dw5QsRy4l2pKfAMzOVY+Nihn91KXdfPBVDHHvdgBSYurknwu2Z+flnyHVNPJQfVLX
         QY+R02PMLdVGk501VyH96EVw5EhAkf5Q/CK9ERvQ1TexKbQxz10EK2InQxnTd1/LZ53v
         dLACMtnqXczoIPBtZ/bOVRyPwmNxCdBG2ltJXqV83pWfSnNJBcJQ9LAkeLNYzoQrpy3+
         7ZGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772793932; x=1773398732;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q0gIJNIcAGUOsJZzstkoZ+rj/OkGKwI2OmgQf4MTA+g=;
        b=xHl5V6AS7GRoerMav8lBfeLT3SkXUv87/S9S8+C423jQ4/WHbhgntyAV3SkA7wYgdH
         u9up5DN1XVVU7qJtHet/CtegiHi1YQyh58FTpeK3OPoUN6v0ZRXnxhq0bQ3zdy/WdvSQ
         duKHNuMVyKbsan3sYtFmONaZJPQ3OD5b4REmcYWWEl+C+hfn1Qicr6nrpaO0t84laRqq
         MfzDLQx4Y5HLodEmyCa4h/n8HLx0coMTMEqPvb5RMbZH9leFeIbIwGTDGzW9UeO6fOBu
         ziVyHcssCl9GkcMUXtyPCamEWUmZcmIyt5NBv74g0g2h2+TNDFFpjcMofU4wnRbd31WL
         mPNg==
X-Forwarded-Encrypted: i=1; AJvYcCWeI+/Ux95xDmUvM9jk8r6cvMkRaMsaZrfsGALN3qZerOejQlXzEGV8yFEPJJPQ6MkQDeY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwSyBNY79jW837KuD1oEqpf28ffBAHbCFQvm3v55/ewMfBlLfw
	a2utVaG67TQXMM6MCryV0eGprLEs+NMg+K1+WwRMxyhw4hcdyIiknn844ymHM3JbDyBLki6CIPX
	iQ3aJtcHvkGK7up7km3X6iMDgF4ydmmlNiVhysmM1J2rTj9BzO9zSpYMZwVqT89LhD+dgVnrOO1
	i1DGeL374lY0oyIx7FVDg1dzfVD8FbbJyoTC5m
X-Gm-Gg: ATEYQzzgLtesL2G+WG3I/AgWd1JD6HomKiNqHwh/lQaBSAWfSdWPtvfuL1/rhUFR+i0
	WUzwEZZs/koa/IURHFOSno/laim5syv+9k5Cxd5d6o5gfD3/R30cpJL9FDy1blA2AvzxBTf+qt6
	qWbIEoQBB/o4ESA+6DU6biUjtvC4DAF5gBIfoOfWPqF8PTkNrcNvb4mrkv/BM4aS9Ba727vKECI
	tyGjRFjffYqbCwf8OOxs/IUFgkWks6tRy82JJzileBjh12g9PyEIUEf1DakRVUtE+0BJQg3d3F8
	NI/if8E=
X-Received: by 2002:a05:6000:2385:b0:439:b60a:b3ed with SMTP id ffacd0b85a97d-439da5552e5mr2545851f8f.9.1772793932165;
        Fri, 06 Mar 2026 02:45:32 -0800 (PST)
X-Received: by 2002:a05:6000:2385:b0:439:b60a:b3ed with SMTP id
 ffacd0b85a97d-439da5552e5mr2545824f8f.9.1772793931689; Fri, 06 Mar 2026
 02:45:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250804064405.4802-1-thijs@raymakers.nl> <ac94394405bf7e878c8ff0acf87db922dc4af48c.camel@infradead.org>
In-Reply-To: <ac94394405bf7e878c8ff0acf87db922dc4af48c.camel@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 6 Mar 2026 11:45:19 +0100
X-Gm-Features: AaiRm52JUs6mwy8ro2yT4HEZ3S2JC02gl4J9DTinX4u6JthR0qmLrhQ0Ms5gqSE
Message-ID: <CABgObfbApSRD=MjdbNOS086eOSPpHtxB9JhX1+0Wbp0nrjxECw@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: x86: use array_index_nospec with indices that
 come from guest
To: David Woodhouse <dwmw2@infradead.org>
Cc: Thijs Raymakers <thijs@raymakers.nl>, kvm <kvm@vger.kernel.org>, 
	"Orazgaliyeva, Anel" <anelkz@amazon.de>, stable <stable@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2B5C821F1CF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-73017-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,infradead.org:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Il gio 5 mar 2026, 21:31 David Woodhouse <dwmw2@infradead.org> ha scritto:
>
> On Mon, 2025-08-04 at 08:44 +0200, Thijs Raymakers wrote:
> > min and dest_id are guest-controlled indices. Using array_index_nospec()
> > after the bounds checks clamps these values to mitigate speculative execution
> > side-channels.
> >
>
> (commit c87bd4dd43a6)
>
> Is this sufficient in the __pv_send_ipi() case?
>
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -852,6 +852,8 @@ static int __pv_send_ipi(unsigned long *ipi_bitmap, struct kvm_apic_map *map,
> >       if (min > map->max_apic_id)
> >               return 0;
> >
> > +     min = array_index_nospec(min, map->max_apic_id + 1);
> > +
> >       for_each_set_bit(i, ipi_bitmap,
> >               min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1))) {
> >               if (map->phys_map[min + i]) {
>                         vcpu = map->phys_map[min + i]->vcpu;
>                         count += kvm_apic_set_irq(vcpu, irq, NULL);
>                 }
>         }
>
> Do we need to protect [min + i] in the loop, rather than just [min]?
>
> The end condition for the for_each_set_bit() loop does mean that it
> won't actually execute past max_apic_id but is that sufficient to
> protect against *speculative* execution?

You would be able to load extra values in the cache but it would not
be a fully guest controlled load in the same way that Spectre wants to
do it. Spectre works because the value used in the speculative load is
way beyond the maximum and points to attacker-controlled memory.

That said it doesn't hurt either, other than a few clock cycles for
not hoisting array_index_nospec out of the loop.

Paolo

>
> I have a variant of this which uses array_index_nospec(min+i, ...)
> *inside* the loop.
>


