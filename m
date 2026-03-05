Return-Path: <kvm+bounces-72960-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8EVgKEQEqmliJgEAu9opvQ
	(envelope-from <kvm+bounces-72960-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 23:31:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D494218EBA
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 23:31:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 87ED3312B1FE
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 22:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75CF63644B3;
	Thu,  5 Mar 2026 22:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XSLjhok2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56880363C68
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 22:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772749684; cv=pass; b=qS9KfIzAgplf26DP1FtWQtnXapzx1rd8Z1mdZtk8TZIf4QeAUkPPCm2GUu0mfcbqS/CLKS6Y8D7dldYUvUs5I0wdMhhU/w5YbdEj9DF97mmMWXWGphpGEQnycnwCSPUu3qKnnadseejNfqOCLGF4kWkyKFRB635lxdmVBL46EEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772749684; c=relaxed/simple;
	bh=p5fofGQFpMgyUNHVfu+CLNG2dMgWZmkRFyjtHgA6LDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kc+5UreecHBd5RGNqgGkR2AAZrXSq7+GCax7CCeFLybIdylU/XCFOySbw7P8k2OTZCwwWcB8JeZKolBDaFcmEwuE5g8yox6vN4K9H/M/Yh5les2I7u3EB4GIDunPgSyNXJvgTKHp/8IdTIhKo8Z5UmmQgilOFFWKVg+JuVXtqC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XSLjhok2; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-661169cd6d8so1897a12.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 14:28:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772749682; cv=none;
        d=google.com; s=arc-20240605;
        b=NoIe71/sECWtRP0yFObybJrnF54Sk1DYLo2Ab+sV4iPyRWafI8CuVjd65JnaqjyGf0
         SwrjnYgSn3jaTD+bOlMPUZK2Hn6BbilhWu1572h2sbShdbHLyal42T1ZGrTsTUGW76EG
         1vOzSU6OOALL9ua0+gzONkpXXjs8tOee1dsRpOnM0Ike8JNrjDgBwrFIt7b7FRZBpYBs
         WkxtXTD+yEngr+MWoddwhSpxgk+eRDE3t6ufjXiLCFdTx22RAC2eP2HVqLTn5mGDjUYx
         GUkeBPZeu7HXaRCJDGd01JS1BmYoNgXZpaml25K6iqsLiepMAjymN+P5KsNhGZ2CWZkR
         YFYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BUUij3Qtk7eI+wZrhr6CCGMZUD25vaaW1Pro/4vyRRA=;
        fh=v1p2fWs87NyTGOySblJ80f0NcR5x+7VxApGE4tjYo9o=;
        b=JNVnFH33+2CuR+G7wjLVIdkFBiS0iGbjQGgPNZFZs4qh9aPtzBR6Zcxt4ZPMTxZ60E
         cBgxCrfPR3rJ0gtZgiaJSZzbM3M19kVoyT15rUJmduj76D5vZH9/sxjDMYOHxyhESdgE
         Xidl3HXzurA36cQhxuGg0m6pRYAvkwigZDck8G7lW/AAqUBtkKeq5a9vl3L1iyNs6MjU
         GKdWLTns3SDGC7edjGHjAVXApzNoR1smYyHK7NEQVTi4sBUTNwnpdYQHcn2RVjBlsHvg
         ZFoX1Ph6KD+4v4gNuNyjnoVZCHKX6tWCcrogFGXOy7CujSm145rVC3SNK+zu0VWsqJYL
         +3iQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772749682; x=1773354482; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BUUij3Qtk7eI+wZrhr6CCGMZUD25vaaW1Pro/4vyRRA=;
        b=XSLjhok2z0k//jRDJo0NZQAqV25AdKSxLvoJUlwC8MFGc+7kD3AmocpXONMmzFTeYn
         lLYursYPyXPj479RV3WPK7TBeoMJqMIYsvE3NN05Ny85Z+IASRzhKO2W6vNfsYXia7zJ
         z5Kh2dJdYYRVMILwNNAWmxjmzL8wxAkjvVYjwFfRCq6INxQf9eyoTMcoEgp9JgNv38zf
         QTJDMQoEWn/5kDHxvc2VEanXQoj6jE2iqF3CPGqQlMXXr+VSUD4ZT+e2FTCljf6v8VXO
         AnWg3lGRld9zchaZ56TEI8+x+Lh3XCGuzrQBu53kLZaYTgTbe9L8fCCAfS7oiXtxwsL7
         NLiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772749682; x=1773354482;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BUUij3Qtk7eI+wZrhr6CCGMZUD25vaaW1Pro/4vyRRA=;
        b=Ixmzn4KmnPWjuWy8Y/eHVDMg0WdV1jV1+9Y+vXGMTvBkxB9uX+CrV8xtm8+Kis0/uZ
         Ft+xkkjU3mEcr3Yul+Zfy8NuOX1jlFHY0fXrIUlcffmMp/Il20xQ3K3mUWgvIKipcfgQ
         qhf0/6ZyjLytlh76JBi+/pSO6sHFfx6AJ0MtFa1dLuoKn9RlW6yikYPqz/JZSO3o0Y+V
         w1T+ovCrEaSJbS8muVToZf9hZqQK21zBUIzDnbelBIMQlp2O583z4oPh3toe6KvoK2Wy
         xfxCTtMCdEJCOTNWDa+z0b3G5+wxvzLTBVmu38SJ1zXSmbzCrd/lKPoXiywdNPYX7zJU
         pBJg==
X-Forwarded-Encrypted: i=1; AJvYcCU8TC5IWTTV1yuLbK4LaSqyT5Q6ANGsC7WS6X5fvLjZmOPUtqXB0ohPyS+LFbiMatZS/O0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuxThsgcM0HSX1z/Cqzz4zno3gMqB9p095kwXa4AY01t4RR6Ov
	sMnx36VT4S64jIbsAuw2QgVYPVT0ZkydP4sl7YOGELBP14CVQzX9NKRUle5Ri03QrInUNMhijYF
	us8W5Sw2eD9Vfaz784/jBiSFswXzQJOXnUJyDgkXO
X-Gm-Gg: ATEYQzz6mW/8xrJllM2QjzXlzBxvzW6Zg1gMArZWPC1M7cjjjIvK8hD0s8YT49q1O2x
	kmbHm/0RGoxfVME3IXUS/Ul2hRQFGs6Xdtk4y0o9RHb54KL1hq3v2LnfEuM2u4x+OF/f48WdI33
	PASUzEjQRROSDzhdN7gpsVv3qh97J/dq2maP55Paz6fJgYqfiQhnH0XMzoREM8uhiYFXBUA0D8u
	swxHlcPhopPG7iQxcuKg+hebh56le9vXwB2TmxL0Ad5e+VwmL7/izlOSfMmSTAIemEPU1nFE8LD
	OLBo9u2zLhGLkcUIcbFcqdGi2eFKThQs8GA/RRA=
X-Received: by 2002:a05:6402:26c3:b0:661:1019:5388 with SMTP id
 4fb4d7f45d1cf-6618dc4a483mr15811a12.10.1772749681209; Thu, 05 Mar 2026
 14:28:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206222829.3758171-1-sagis@google.com> <20260206222829.3758171-2-sagis@google.com>
 <20260217180511.rvgsx7y45xfmrxvz@amd.com> <037084a1-2019-4bd2-b1ed-7f34f9128e37@amd.com>
 <20260217191635.swit2awsmwrj57th@amd.com> <aZS_ePUyLcTyZ4Am@google.com>
In-Reply-To: <aZS_ePUyLcTyZ4Am@google.com>
From: Sagi Shahar <sagis@google.com>
Date: Thu, 5 Mar 2026 16:27:48 -0600
X-Gm-Features: AaiRm5334z_4bkOOOro7BUKnb0laFSF7mgIjilyebgCsWunDpdebWfBRXx0w8DU
Message-ID: <CAAhR5DHLAF7gsOhUGWQRX0f2nK8_efg_L+h3fCiYCym-u5tNGg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] KVM: TDX: Allow userspace to return errors to
 guest for MAPGPA
To: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0D494218EBA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sagis@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72960-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[google.com:+]
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 1:20=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Feb 17, 2026, Michael Roth wrote:
> > On Tue, Feb 17, 2026 at 12:45:52PM -0600, Tom Lendacky wrote:
> > > On 2/17/26 12:05, Michael Roth wrote:
> > > >> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > >> index 2d7a4d52ccfb..056a44b9d78b 100644
> > > >> --- a/arch/x86/kvm/vmx/tdx.c
> > > >> +++ b/arch/x86/kvm/vmx/tdx.c
> > > >> @@ -1186,10 +1186,21 @@ static void __tdx_map_gpa(struct vcpu_tdx =
*tdx);
> > > >>
> > > >>  static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
> > > >>  {
> > > >> +        u64 hypercall_ret =3D READ_ONCE(vcpu->run->hypercall.ret)=
;
> > > >>          struct vcpu_tdx *tdx =3D to_tdx(vcpu);
> > > >>
> > > >> -        if (vcpu->run->hypercall.ret) {
> > > >> -                tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_IN=
VALID_OPERAND);
> > > >> +        if (hypercall_ret) {
> > > >> +                if (hypercall_ret =3D=3D EAGAIN) {
> > > >> +                        tdvmcall_set_return_code(vcpu, TDVMCALL_S=
TATUS_RETRY);
> > > >> +                } else if (vcpu->run->hypercall.ret =3D=3D EINVAL=
) {
> > > >> +                        tdvmcall_set_return_code(
> > > >> +                                vcpu, TDVMCALL_STATUS_INVALID_OPE=
RAND);
> > > >> +                } else {
> > > >> +                        WARN_ON_ONCE(
> > > >> +                                kvm_is_valid_map_gpa_range_ret(hy=
percall_ret));
> > > >> +                        return -EINVAL;
> > > >> +                }
> > > >> +
> > > >>                  tdx->vp_enter_args.r11 =3D tdx->map_gpa_next;
> > > >>                  return 1;
> > > >>          }
> > > >
> > > > Maybe slightly more readable?
> > > >
> > > >     switch (hypercall_ret) {
> > > >     case EAGAIN:
> > > >         tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
> > > >         /* fallthrough */
> > >
> > > I think you want a break here, not a fallthrough, so that you don't s=
et
> > > the return code twice with the last one not being correct for EAGAIN.
> >
> > Doh, thanks for the catch. I guess a break for the EINVAL case as well =
would
> > be more consistent then.
> >
> >     switch (hypercall_ret) {
> >     case EAGAIN:
> >         tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
> >         break;
> >     case EINVAL:
> >         tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND)=
;
> >         break;
> >     case 0:
> >         break;
> >     case default:
> >         WARN_ON_ONCE(kvm_is_valid_map_gpa_range_ret(hypercall_ret));
> >         return -EINVAL;
> >     }
> >
> >     tdx->vp_enter_args.r11 =3D tdx->map_gpa_next;
> >     return 1;
>
> Heh, except then KVM will fail to handle the next chunk on success.  I li=
ke the
> idea of a switch statement, so what if we add that and dedup the error ha=
ndling?
>
> static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
> {
>         u64 hypercall_ret =3D READ_ONCE(vcpu->run->hypercall.ret);
>         struct vcpu_tdx *tdx =3D to_tdx(vcpu);
>         long rc;
>
>         switch (hypercall_ret) {
>         case 0:
>                 break;
>         case EAGAIN:
>                 rc =3D TDVMCALL_STATUS_RETRY;
>                 goto propagate_error;
>         case EINVAL:
>                 rc =3D TDVMCALL_STATUS_INVALID_OPERAND;
>                 goto propagate_error;
>         default:
>                 WARN_ON_ONCE(kvm_is_valid_map_gpa_range_ret(hypercall_ret=
));
>                 return -EINVAL;
>         }
>
>         tdx->map_gpa_next +=3D TDX_MAP_GPA_MAX_LEN;
>         if (tdx->map_gpa_next >=3D tdx->map_gpa_end)
>                 return 1;
>
>         /*
>          * Stop processing the remaining part if there is a pending inter=
rupt,
>          * which could be qualified to deliver.  Skip checking pending RV=
I for
>          * TDVMCALL_MAP_GPA, see comments in tdx_protected_apic_has_inter=
rupt().
>          */
>         if (kvm_vcpu_has_events(vcpu)) {
>                 rc =3D TDVMCALL_STATUS_RETRY;
>                 goto propagate_error;
>         }
>
>         __tdx_map_gpa(tdx);
>         return 0;
>
> propagate_error:
>         tdvmcall_set_return_code(vcpu, rc);
>         tdx->vp_enter_args.r11 =3D tdx->map_gpa_next;
>         return 1;
> }

Thanks for the review. I updated the code and sent out v4 for review.

