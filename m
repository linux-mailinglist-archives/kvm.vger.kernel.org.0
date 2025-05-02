Return-Path: <kvm+bounces-45205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E0CAAA6E0B
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 11:25:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D5931BC69AA
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 09:25:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8395822CBD9;
	Fri,  2 May 2025 09:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="pAdWTsNj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BFA22D7B3
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 09:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746177906; cv=none; b=qUvYsA+Bh5+Vx8Jj0ERJZXbxND+VLpCZ11/3JRBsf8Qx5/FinImaoHFKWrsh8r5WajdXPCCPacuUSE/IaBWn0gbhDI2x4XlrcQV8m4TcNJBOLtZdwhJVUdiz0umTw2rSxZyfLXXs2nIHSjOjdLXLSNV44BERTgTE/g6qYSwNmf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746177906; c=relaxed/simple;
	bh=/LaTikKXn/OQ2h2DJo2YJdc9uHS9vjVI4y4cjPXILDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iTxafdS8coZa/WyEkecyLS0+Ep9TOT3FCcQbpr2GKgzsO37j+is3AW+ZRSzZvyxtHsDjqy8a4U5xvDtS3gvxtjisauoUY0D33i2K6mbAso71/Pqsg4eja4ebSZV/saWErAw0HisoRXC+khGoydtjHnpu7/Yq/Nnz00i9xgrqRDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=pAdWTsNj; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-39d83782ef6so1925925f8f.0
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 02:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1746177903; x=1746782703; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OYlDfYjYT+B1xAbCEbapK3iC8ne1kDR5y2hxe1JkOrM=;
        b=pAdWTsNjKkfGOqeHpHPgAicnp/lnT+8+KSP2rSrm7yQ7O6CRUatoIhG9DRFIo/n8ZK
         dewdw+OGg85AUOk0gGX0910brBvelA49ztq7xBtEb2XtED08zEzj03NewgqymoIP2V1X
         iFvEO/Q32MeCmsGzwRYOVfvykOrHIdLFIKXf3L6XYMvXXODpCCBWBBHdJ8ZuJ/jjCkyF
         oJN02pGImS4GkwEfCrjG9F17Ieuxj+fwbuESHIPMUHl/E+5fGpHT7p+bObEgxcuTbA7U
         Wm94BWx4EMcfnnbIQFJUHfHW35FSxtRLC3U9xZD9KVV+cUW9irUkO6Jx5XAcTvogay+W
         04rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746177903; x=1746782703;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OYlDfYjYT+B1xAbCEbapK3iC8ne1kDR5y2hxe1JkOrM=;
        b=G8jx+I+ctAgV5b5PcIRqosTxqSlSQDIOFaAVAmywOz/53gHwKLJmyFabe5LUNZoTQ7
         ryo2q1qMTl+D+av9ITOsPhMpBCbr/BJZsogZpNxtgn0Z8jzDcYG4O47u8aqhJnV0W2Fi
         kl/iP36gRyi2RM/AWmqx13WMKe50LgmcPolx0EOoPT/QbsiiPjFNcqSFX98GRVWScScf
         A2USNsHmPPAdMros3kF5NUtz+Vv+yN/cWIfl4iAGRKkMAc0UQe70rztTP95Uyr/IpioF
         eMgaT51Fb9w12u3aZ0/yerRzdjvhBONup7bvIOGTiHF3fZe7ir12dq1jeFgQv4P5k2qv
         o6OQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfrOyHzOFeRP3AoXUqwmJQdggDgt2GTIPXIpTY15cMJN6PmUnw8ik7KPLKDGBbwiXIzMY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvjiX9HeYumB75ojwhp8H+mP//jbJwNeSSeZgip8jN6zUtw8qF
	LtC2zy2H22IRS07iS69k1Mmqptg91PlxsQ6bzUrh8jPXRrNyhtx3CFM3pdPS5NgdySY6tSWT4JG
	bH/g=
X-Gm-Gg: ASbGncuytVFy0r220Y7+5c8HKzFqOu3tMa/Yrsn/t3iwjy0LXpb5r5YRduU/4esm4v/
	SsMVh3EHQjD8FqmJw7WkLRpd5DdpOjrGeUexQT5CEPT1LtGf/MTlw4Kut1jEF3ToM+2dbze0a9W
	1+mJtyId3NCvSgT/ejO/Iy9qFFUp7SnupzZuh2B9rJYivmSXSZDWV2LlnEB815jWREDA5J5ByCs
	Tm9k54wFRVWd87DR5UrN2A9gdzGYLgCnUtVrZ6jc0/cxHLSBgnzJBe0LsDCPEF68lnjI9HftY2c
	vzMMX2d+WFyBDhAJTwziMLx7rnZR
X-Google-Smtp-Source: AGHT+IEBaSRLrmn700fqG0VF/eAkmLa6meKVbY5iiQltupuJV9RCc+EkLCIqNLj+fOJuSvuhPMdslg==
X-Received: by 2002:a05:6000:3101:b0:3a0:92d9:dae with SMTP id ffacd0b85a97d-3a09402ca45mr4098508f8f.5.1746177903339;
        Fri, 02 May 2025 02:25:03 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b89d1636sm38301275e9.13.2025.05.02.02.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 02:25:02 -0700 (PDT)
Date: Fri, 2 May 2025 11:25:02 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Huth <thuth@redhat.com>, Andrew Jones <andrew.jones@linux.dev>, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] scripts: Search the entire string for the
 correct accelerator
Message-ID: <20250502-6ff7655f7f51e12791535815@orel>
References: <20250425220557.989650-1-seanjc@google.com>
 <20250426-8f1b81cc50c34db23f34110b@orel>
 <aBP3HHroTm6hPK7F@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBP3HHroTm6hPK7F@google.com>

On Thu, May 01, 2025 at 03:35:08PM -0700, Sean Christopherson wrote:
> On Sat, Apr 26, 2025, Andrew Jones wrote:
> > On Fri, Apr 25, 2025 at 03:05:57PM -0700, Sean Christopherson wrote:
> > > Search the entire ACCEL string for the required accelerator as searching
> > > for an exact match incorrectly rejects ACCEL when additional accelerator
> > > specific options are provided, e.g.
> > > 
> > >   SKIP pmu (kvm only, but ACCEL=kvm,kernel_irqchip=on)
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  scripts/runtime.bash | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> > > index 4b9c7d6b..59d1727c 100644
> > > --- a/scripts/runtime.bash
> > > +++ b/scripts/runtime.bash
> > > @@ -126,7 +126,7 @@ function run()
> > >          machine="$MACHINE"
> > >      fi
> > >  
> > > -    if [ -n "$accel" ] && [ -n "$ACCEL" ] && [ "$accel" != "$ACCEL" ]; then
> > > +    if [ -n "$accel" ] && [ -n "$ACCEL" ] && [[ ! "$ACCEL" =~ $accel ]]; then
> > 
> > Let's use
> > 
> >  [[ ! $ACCEL =~ ^$accel(,.*|$) ]]
> > 
> > to be a bit more precise.
> 
> Sadist.  :-)

Hehe

> 
> Why the ".*"?  Isn't that the same as:
> 
>   [[ ! "$ACCEL" =~ ^$accel(,|$) ]]
> 
> Or are my regex skills worse than I realize (and I fully realize they're really,
> really bad)?

Oops, that ".*" should have been a ".+" since the intention was to avoid
accepting 'kvm,', but, of course you're right, that .* still allows it,
making it equivalent to nothing at all.

We can either just drop the .* and accept 'kvm,' (because why not) or
change that * to +.

Thanks,
drew

