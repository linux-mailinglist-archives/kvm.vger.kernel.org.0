Return-Path: <kvm+bounces-72970-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yJZ+BEsrqmlaMgEAu9opvQ
	(envelope-from <kvm+bounces-72970-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 02:18:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DCAA21A2E4
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 02:18:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 71C5E302F397
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 01:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5361315D29;
	Fri,  6 Mar 2026 01:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zm/9JCYY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598A21E89C
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 01:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772759862; cv=pass; b=XQ+OcmygRG2zUxbZNwG23/vqCq5nXn1kdUJqiWljQLq47r46oxpTsG8JFpn6/MaqYIFFY5DRduvC8EEj4moNY5z01AmpQ6rJMnqlgNhDIcLHkxRjyh8pHGnsburwWqAlqjFcpNnFqMGRFyoNkjJJoD0mCg4J2x3Pg/7lYCO0Hxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772759862; c=relaxed/simple;
	bh=JGQ8Eig3kstIjjlOZMsTGCGbpSyv6mE0+bEoCruDScI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PhLwtLYquxupOscbeq5NkmCJMDDEkxN2gPKYcE01HA2afgf2LBYq7dCp/98JPhVWiycZbsKEoaTEwBsQNegmeoApMj9f1d6y9+xOevR+Ch0ud7KoQg2TV58l8IXE+swO8jo4drkODptWyKXDhBtA7ojLVq3lge0tFNQz9s/mX1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zm/9JCYY; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-661169cd6d8so3315a12.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 17:17:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772759858; cv=none;
        d=google.com; s=arc-20240605;
        b=TytOHDUqaRMFZ9LZtIhOmU+CCHMRFEr1A5YtZW02dA/rTDGMR+G3hR4dRAx80OPyyJ
         89MFMYLN9z7JAqK0smNE1iTR+IMO9GxIzORXBmz26kVpI3gglISe3lwTxp6Kf98EwCIt
         ZKLyvOEPRvPtQDLgdNXLIor5dZsZhPsoylsp8oK9uz6yOLn6hZcWEefOmukxcDo5+ixE
         I8a8TprjkXzUs/wDDkxF7skw+SfqS0nal9lGbIs7vXNffjr4ArVZ1EKv7Y0vGmsm2j1B
         8CFbXix1XlQkvvC+dPpQV9+DnqJIwDoIPJ8o6K2KdYhoiDtd5DdhPoUMnodbEYQq0ZZJ
         OVfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6drOilk4n5nPtpHoBrBojAsaC3RhqdZ+PN0pMb7ojJk=;
        fh=HevODpbycZJsDTcYCDC6u13JphrWu75rjIeyTNfmA50=;
        b=WTzlA/3pBrj4PbdRf/V7fvqueuLZuLjeuHSZOJT9yxYfl38lXzZKv9hylIRt/cXxqS
         fNw18B6haVgnE5F2nef64l58qp+b0H+jOMDAmDft9QN9p2YNB3DG+EIosEgVMdDa5bkU
         Dk7vs9kjEooun6bhOcwFx2XipfPK2xaxPo+GqUBcpbZ1b5dlFxjYJfrmPEzCBqPKJ3T9
         U2z8l4Hb1VgEu8Rp5hkZ+5FfWrQnUgXK0qjHkfs57A0LH7m8K53OwYU81qCGZD26B/8q
         zionRzpR6UudWXJ6otySwD7L8fS8MX1m+kiNed34b8iHb+ffhl2mlIyhPnZCh59IpFDO
         BWkQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772759858; x=1773364658; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6drOilk4n5nPtpHoBrBojAsaC3RhqdZ+PN0pMb7ojJk=;
        b=Zm/9JCYY68tFtWBWLxwzSsIJEnWFiKhQ7INjSsbdlNFwYOr5vIRtxu+32xs+mjqG28
         /2omun/Ur+F+TrFIYDzUW8S9+dEN66MF/wCDu+XSrGW8wDsDu9W0Y3ZUXD+EW6+9w/Qn
         pt4ZtVPGzWev7e+/NQyCIQwrEy4icOFWFmvshfAayfm/GPLZpJ8SmOit69gq0oXHmK6s
         i+FmwZ3qflRHevpr3wKwaF+z4aCTL2pXn2bRu//Kg1Oq9oryugOa6feGG/9Sz6Ifq1LA
         dHj2stZduspx/kwfrzBn9c/7UZts3kKzl7vwSXDelVsCH1TOtUxr7s0QD05kSjvADcvQ
         ijPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772759858; x=1773364658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6drOilk4n5nPtpHoBrBojAsaC3RhqdZ+PN0pMb7ojJk=;
        b=H4wd80sJLqRTkn1kNL9NUWw0wdwsCQI4b1+oGmx3229UxEBL54prrh5p8Fr78pMCCo
         gavrG3sxkmNuOmr5g0CHzc8ES2J+QRmbEnaXRAQRUQlAbt9y7MvkUE2lII2ICHosuAIC
         Rb2WhDbm/vZnv6L175UIRCVLg8r9gDj+jI0qQT2T2sKoSyQFYCA6fU1PE+yW42XM+HGm
         pMxHo4rnGdapejSU55odytwNyZNLrIx3PEzKMaeUCfaKv9lDr1qJZ0RRSCw+4EyHSEi1
         tmS6Ov1xI4lZuk2LtLx1T9h7K2CVlNZCPwpuNqWyOzYf+/x4BbjDAjLnI0pauYFoP52B
         wETQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3vBLtNWDm/SICbb0/Eix2A+yPCUH8t62qdK+AS9NicKLG4UrkPHDOmYLIcNH5lJLOSfQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfTIWtPPO+SCHTG5Y3fmY1efbrGzCPnQDLvgWUr0vx6CGtHt7+
	T5WJYmOhBg8wG/ygHxeMlQ0vMfI5DSIaf6kWfX9sv0Z4kMair+0maJ1rVu6/gbDo64p2tcewlOS
	1ja9pBIv7AaMMJOyeZcj0k9hXobR7sLMjgCXgw+6zZmFTXT+roi3iMri90CY=
X-Gm-Gg: ATEYQzxUfMIxZ4fPp/W3n+vBLHn6fWGgr71BNHoNp+Q8R3Ph4cAO6FevbTsON8Xa0XH
	/30uzD6hZ252LxLvGu1iwDKMUqIqejcEtZBAB6I3mZvO5VqzltxUaVYY9EthFvTkfIaY0qy580B
	/dHQ1z/Su4Q0qcG/VH016aCms0fqWqYMEOggkWBwl5X+Z7bH/5/Bdf0gtkNm0fFmzAH0LA3O5zj
	YPjViXAQK/fFavyRzm7WKD9kNJcnQhbOseWp647POf9ZJq/NalCNUtNqMG5C573/icKS4OD190U
	sJQtuzIBA7ZZoaSu/A==
X-Received: by 2002:aa7:dd02:0:b0:65c:212b:6b6 with SMTP id
 4fb4d7f45d1cf-661951a2222mr8767a12.15.1772759857439; Thu, 05 Mar 2026
 17:17:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303003421.2185681-1-yosry@kernel.org> <20260303003421.2185681-27-yosry@kernel.org>
 <CALMp9eSMtzDJn7tGtbj=zLYpcU7Tc7XjcWBRZH7Aa5YihSmN7g@mail.gmail.com>
 <CAO9r8zMhwdc6y1JPxmoJOaH8g1i7NuhPo4V1iOhsc7WFskAPFw@mail.gmail.com>
 <CALMp9eRzy+C1KmEvt1FDXJrdhmXyyur8yPCr1q2M+AfNUcvnsQ@mail.gmail.com> <CAO9r8zPRJGde9PruGkc1TGvbSU=N=pFMo5uc78XNJYKMX0rUNg@mail.gmail.com>
In-Reply-To: <CAO9r8zPRJGde9PruGkc1TGvbSU=N=pFMo5uc78XNJYKMX0rUNg@mail.gmail.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 5 Mar 2026 17:17:25 -0800
X-Gm-Features: AaiRm52_CveytujBgh7q3tcgYPFubixiZjJYDIMMtzhWAEuRUjBpRVmyBg4oTMo
Message-ID: <CALMp9eQMqZa5ci6RsroNZEEpTTx_5pBPTLxk_zOBaA8_Vy4jyw@mail.gmail.com>
Subject: Re: [PATCH v7 26/26] KVM: selftest: Add a selftest for VMRUN/#VMEXIT
 with unmappable vmcb12
To: Yosry Ahmed <yosry@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8DCAA21A2E4
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
	TAGGED_FROM(0.00)[bounces-72970-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Thu, Mar 5, 2026 at 4:40=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> On Thu, Mar 5, 2026 at 4:05=E2=80=AFPM Jim Mattson <jmattson@google.com> =
wrote:
> >
> > On Thu, Mar 5, 2026 at 2:52=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> w=
rote:
> > >
> > > On Thu, Mar 5, 2026 at 2:30=E2=80=AFPM Jim Mattson <jmattson@google.c=
om> wrote:
> > > >
> > > > On Mon, Mar 2, 2026 at 4:43=E2=80=AFPM Yosry Ahmed <yosry@kernel.or=
g> wrote:
> > > > >
> > > > > Add a test that verifies that KVM correctly injects a #GP for nes=
ted
> > > > > VMRUN and a shutdown for nested #VMEXIT, if the GPA of vmcb12 can=
not be
> > > > > mapped.
> > > > >
> > > > > Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> > > > > ...
> > > > > +       /*
> > > > > +        * Find the max legal GPA that is not backed by a memslot=
 (i.e. cannot
> > > > > +        * be mapped by KVM).
> > > > > +        */
> > > > > +       maxphyaddr =3D kvm_cpuid_property(vcpu->cpuid, X86_PROPER=
TY_MAX_PHY_ADDR);
> > > > > +       max_legal_gpa =3D BIT_ULL(maxphyaddr) - PAGE_SIZE;
> > > > > +       vcpu_alloc_svm(vm, &nested_gva);
> > > > > +       vcpu_args_set(vcpu, 2, nested_gva, max_legal_gpa);
> > > > > +
> > > > > +       /* VMRUN with max_legal_gpa, KVM injects a #GP */
> > > > > +       vcpu_run(vcpu);
> > > > > +       TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> > > > > +       TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
> > > > > +       TEST_ASSERT_EQ(uc.args[1], SYNC_GP);
> > > >
> > > > Why would this raise #GP? That isn't architected behavior.
> > >
> > > I don't see architected behavior in the APM for what happens if VMRUN
> > > fails to load the VMCB from memory. I guess it should be the same as
> > > what would happen if a PTE is pointing to a physical address that
> > > doesn't exist? Maybe #MC?
> >
> > Reads from non-existent memory return all 1's
>
> Today I learned :) Do all x86 CPUs do this?

Yes. If no device claims the address, reads return all 1s. I think you
can thank pull-up resistors for that.

> > so I would expect a #VMEXIT with exitcode VMEXIT_INVALID.
>
> This would actually simplify the logic, as it would be the same
> failure mode as failed consistency checks. That being said, KVM has
> been injecting a #GP when it fails to map vmcb12 since the beginning.

KVM has never been known for its attention to detail.

> It also does the same thing for VMSAVE/VMLOAD, which seems to also not
> be architectural. This would be more annoying to handle correctly
> because we'll need to copy all 1's to the relevant fields in vmcb12 or
> vmcb01.

Or just exit to userspace with
KVM_EXIT_INTERNAL_ERROR/KVM_INTERNAL_ERROR_EMULATION. I think on the
VMX side, this sort of thing goes through kvm_handle_memory_failure().

