Return-Path: <kvm+bounces-71425-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2js6CWfgmGmHNwMAu9opvQ
	(envelope-from <kvm+bounces-71425-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 23:29:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AA6A116B396
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 23:29:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DE36230F1AB2
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 22:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A2413126C1;
	Fri, 20 Feb 2026 22:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sYYBScYW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5700930FC10
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 22:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771626411; cv=pass; b=RearKxMSRU95UXt26T8LPgBdhZC8xh+qP5Sg5cgnwYgkbCXdy8tSWbMnxTkKJeM0bfo7LzOd9qtboUK/6XFL58i+rrORsYn/YxTER5Vsie+Ky8kOE/B5ePVJMZUIrwZfiDUVzDiIBicOdQd/bHK1083aOO9sdd2fqEykXoZqpmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771626411; c=relaxed/simple;
	bh=SuFFXamwm+ptnoWMzh0eeppJs25M/vVzrHN4bcP/QfE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LlcJAM0Chypw419eqQiKPR2walWbBMbrh4wukKpt8j/OecJ0iG6EUKSy+JYq6E/OTmxMouvJ+Q2XNFefJkejdbRajucyyIPZcPeZOxQCD2sr9OpEY1JxUnFCcduTQT6TlgYwC5+Asd7upmTvEGjgd80QqAdxhdNS9QzwQXFdtCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sYYBScYW; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-65821afe680so1382a12.1
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 14:26:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771626408; cv=none;
        d=google.com; s=arc-20240605;
        b=aaY2XhUbvjR5mkrVzpXJGDhI6AULUSX0m+xKxebKtWpGTc5apM9XBMIFYa3bclN0FM
         6+S3xrwnsQXTfO1fn7t3j82LZ+RYNVpxOpLAopQs5DFOIri85r2HeUyctU1D60MwT81F
         gAzVGqV01mtgD1uGKWjTtwOQw0aaQWdzsEzlDx0EQITvxN36Nd8VLhpaf/nJR/6bXQkQ
         sgksq+ana2j0Qi0KMQtmEGCuipR+DqdleDWrl1mXidq3aL2aEiG6wOOzA9P/rXNjjHcj
         21m0h9olJmI207rSqSu54UMNRmsAPHtJf2w3bGqCHzoF89R5hJjq9giHcdpz/8Z+hs4z
         6dJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WhONdEzZ5uYj0tWSg+PyKRuIzspHfnI5Pzgh7yFndao=;
        fh=zip/TCwoQ1e0IeHCZ6Sh80SFM0DUdUrDJ2RRSUeMCcY=;
        b=DGy7hkec8NfX6uZosFi8One8fVQZS+WyroElDxTtSrVNzLmqIoBjwV3jT4+ss/QmXH
         zxJklIeJc3U+bB3tOlR4TO/WevBaju9YXWQIpRYo8qEPtEpwVUWToGEbuTjuPIh+sgjA
         O451NfMaIftuGjZxwg4W0+7VmvduCzWK5fucjSD1UUrTlxsTnUaupWX2ztG4ycqTnRQY
         b/29qBDOiuB/tlB6O67gZLFTJdTLqe3NXfNlNuFgbP38bJiyzbA+e5pyRYTM7omcET6j
         9C+2YHjqan1DwmJAdC1JfHQxYCVDiD9MCi8KE1wFnIdbqEszxCtLoziZUpECZvIpIUlF
         kpQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771626408; x=1772231208; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WhONdEzZ5uYj0tWSg+PyKRuIzspHfnI5Pzgh7yFndao=;
        b=sYYBScYW26MrqMFgWTyDNSeR+2o+OliRs8oL5C2PlcPSBusYujbQ6TIG7MaBE21rT1
         BdA3Sj3mFWb3fjMStbRw0gl+quQ/xiQkbs/aPnbXRZpxg3+amxi/ht1roMJQG8t7yLmg
         ZjOZ6pz6oWqPfeq3oR4YT0KSSKxr40kUpMjx8cWxyC0Ehkx/1TWqhMZrlOIQrN2FTyI6
         YxmjfX60P6sFozGj3mTaOiS1BpsHqNOEuyxkxvgzh9uos2nZO1PMS+vEeZH2n3DsQ7tG
         KZzPANNL+VKOOsnidrzW+Wsayg12uc5LWq0NPQjJWJw3A5rExGwu+QGUcutXarjVvVoy
         3u3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771626408; x=1772231208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WhONdEzZ5uYj0tWSg+PyKRuIzspHfnI5Pzgh7yFndao=;
        b=D/2aaOpRpa6vRE9kNzuG1N+3EBJct5ZdGKBupyJgwnf8ZGChNTQ4DRx++EHDIHx8et
         nCTeB7HEZaASm9wCEX6t3AgGV16tiZjOz00Qj/9QUNu2or6097LUH38UOwUWrS/7kVBH
         Xrx7xwqITrzfx7r8QVN3rZGXiVbCrQxcESSvVeKT8hr9O23h/Y0iqESn4FrCmTpViXNR
         qwA83tYujNuauUvvRiclDq11xQQH1FjH21yUFi8U91x0p1OJCsA2bylvcEji12eqbteL
         2MbuEUle8ZcGYd0m3/ZVIVDUsm9O2rBSpKCJmjm/oUzknxKAQFcTte30Op/Qfkdj5uOZ
         jhXA==
X-Forwarded-Encrypted: i=1; AJvYcCXZTKOkEepjSINcmhOBaNYMwjprWETp/+BFrkDarl9UI+uhEH1o3OAKq/uOT1aGUdsBo04=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwnROMhayuWWqyix6D79vXv3DOg+6bazPTAvyyLSk+swjgt/pD
	xzBmTY1Lg48oXXGLPoyz5FLP2ZObyV5TWVS9H8ke4J/aEt08H8pOe/r13BBeMK4143ciiZ+I6j4
	fhTMnsfX2y6gyTX4ixvyDpgEqA7BAfz/485PI8pan
X-Gm-Gg: AZuq6aJWJnjQ7Snjy8HQc7N0ttVCzbDFB8H1WVKoZyOZs0E8/5E/pXrx2bEmG0LfpvO
	HbBia+jgjgc4PSqI4zSmQkKnn39bEAlAjsq41u7+tM95GJkpEdsCxKdZAMQ8yZ/ee4AXSvjoGzD
	lTsNtm9Ec3z/+fLvOLBO8Co679JneqpRRLsgdvfx8cVPme4Fk8Ne50X3yDC07e5HbmzVz3KNx3I
	Ytr0Ug+y5qSs1JaA3o9JEstpZDCifrE0UUEI3/uxy3rBC24W6+IHxb/Y5IKEjcRzaqSdPHEf43M
	wqAAx2TQfVvHDiRJMw==
X-Received: by 2002:a05:6402:a2ca:10b0:65a:3032:5f99 with SMTP id
 4fb4d7f45d1cf-65eab89c28dmr9467a12.14.1771626407377; Fri, 20 Feb 2026
 14:26:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260212155905.3448571-1-jmattson@google.com> <20260212155905.3448571-3-jmattson@google.com>
 <y2c76qtfmwgy4ncypthcm25wedlapwknjnfyptu62qmlbdqa7k@udzmtcddsmwa>
In-Reply-To: <y2c76qtfmwgy4ncypthcm25wedlapwknjnfyptu62qmlbdqa7k@udzmtcddsmwa>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 20 Feb 2026 14:26:34 -0800
X-Gm-Features: AaiRm51T2rP331JnlXcrOOihyG7FCkVkRkv247heUN-CWGu0lt_x6RRhcjTjip4
Message-ID: <CALMp9eTNpSDkEgVBb81n_vQrd63Txg+gMBCGh-DAcN5yOuhLxQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/8] KVM: x86: nSVM: Cache and validate vmcb12 g_pat
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
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
	TAGGED_FROM(0.00)[bounces-71425-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AA6A116B396
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 4:22=E2=80=AFPM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:

> > @@ -2006,13 +2012,16 @@ static int svm_set_nested_state(struct kvm_vcpu=
 *vcpu,
> >
> >       /*
> >        * Validate host state saved from before VMRUN (see
> > -      * nested_svm_check_permissions).
> > +      * nested_svm_check_permissions). Note that the g_pat field is no=
t
> > +      * validated, because (a) it may have been clobbered by SMM befor=
e
> > +      * KVM_GET_NESTED_STATE, and (b) it is not loaded at emulated
> > +      * #VMEXIT.
>
> (b) here means that svm_copy_vmrun_state() does not copy it to vmcb01,
> and the value is restored by KVM_SET_MSRS, right?

Actually, (b) refers to the open-coded block of assignments in
nested_svm_vmexit() under the comment:

        /*
         * Restore processor state that had been saved in vmcb01
         */

> If my understanding is correct:
>
> Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

