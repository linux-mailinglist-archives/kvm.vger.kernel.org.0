Return-Path: <kvm+bounces-3215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C9F7801B6C
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:12:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 28BEDB20F47
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 08:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C2C8D29F;
	Sat,  2 Dec 2023 08:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="PeelzZC8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE289196
	for <kvm@vger.kernel.org>; Sat,  2 Dec 2023 00:12:37 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-40b54261524so30346165e9.3
        for <kvm@vger.kernel.org>; Sat, 02 Dec 2023 00:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701504756; x=1702109556; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CVX2kpuxMR/gQOGxwhkAyQ2ljhTWu/mzS3efRZJyhSQ=;
        b=PeelzZC8+Gs4q3IoctlEHwNoTntOQi/EHAWeNGCvuTiuxZTtaJPCGrw4CWGE8j4jC7
         mWY2Opj/NfdsutwE/RiJEwMwWvLuaoadCwo1Tn9FzflhGWHHJNjkz6Ku7EjZH5WcXjoY
         jIzpvXp9IesyuoX+P9ARbsb8fZh3flsBGG3e/DHgO548FH9rea9Fq9KeZ5DNPxyE+RNx
         Uec9YfuSV/5YnyNYMgahrV/nqihndyTP1NgulMrixHxTkcq+OR2y9+wF0Q88dHYKft4I
         dNi1qgtfblAi8CbXQmxlwXaCMY18lwlpJfy+7jSuKXekXZ8fZjfX4yCevmoSUczpz5wn
         XWrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701504756; x=1702109556;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CVX2kpuxMR/gQOGxwhkAyQ2ljhTWu/mzS3efRZJyhSQ=;
        b=EDgOqOUF7u8jaYoNqqUXbohp0gwmzG6x1po4gnLHQeO0kLni2fBH3COZp0QM10oXvf
         rjpPBqHVBKHXVZJ8RrP8SgU9xWNyFZ5Q+5UhoL+1K0YnOrUEF7qlN2LnKYSqLcHwwK82
         b2vbAL+W8/Bz15vJA4gaHuNLMoqJK2kcuIqRtPSf5Zg/v73DSAZo10vADN8LXyKmH3ON
         7CI1YmXIxg/DnPxbwRXZqCrpDBGhMtl0b7jWC7Jlo0A/qvaW/hzgFmpapGTSeBaDVKe/
         qxBAisCDZgUdNN7usOq3PJZKf/tQ99+H4cxDyuYJdzQw1GmYXkHbUjYo4iqgL4w/hwE6
         R1qA==
X-Gm-Message-State: AOJu0YxL+9HAlOud9PPg0mCjLSpBR9DAksK2GlZP+DYeYtsllB9HCjKK
	XXv1PYsHzAXbHZPBXejlAnvHdA==
X-Google-Smtp-Source: AGHT+IEUK+ue+JgPyJTnysv1yet0GgFn+9iBizzS8rLx+WfhJQ9tDiQnhK4ki/wLaMJ6+T1dIvWEwg==
X-Received: by 2002:a05:600c:21d0:b0:40b:5e59:cca3 with SMTP id x16-20020a05600c21d000b0040b5e59cca3mr835423wmj.132.1701504756302;
        Sat, 02 Dec 2023 00:12:36 -0800 (PST)
Received: from localhost ([2001:9e8:8c06:1:fc31:ac12:b4b1:32fe])
        by smtp.gmail.com with ESMTPSA id t20-20020a05600c451400b004094e565e71sm7852194wmo.23.2023.12.02.00.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Dec 2023 00:12:35 -0800 (PST)
Date: Sat, 2 Dec 2023 09:12:34 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	maz@kernel.org, oliver.upton@linux.dev
Subject: Re: [PATCH] KVM: selftests: Drop newline from __TEST_REQUIRE
Message-ID: <20231202-95468f21e7d2d4c90f475079@orel>
References: <20231130182832.54603-2-ajones@ventanamicro.com>
 <ZWjfjAnZcomGa1Ey@google.com>
 <ZWoE_55_6q7lqJvo@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWoE_55_6q7lqJvo@google.com>

On Fri, Dec 01, 2023 at 08:08:31AM -0800, Sean Christopherson wrote:
> On Thu, Nov 30, 2023, Sean Christopherson wrote:
> > On Thu, Nov 30, 2023, Andrew Jones wrote:
> > > A few __TEST_REQUIRE callers are appending their own newline, resulting
> > > in an extra one being output. Rather than remove the newlines from
> > > those callers, remove it from __TEST_REQUIRE and add newlines to all
> > > the other callers, as __TEST_REQUIRE was the only output function
> > > appending newlines and consistency is a good thing.
> > > 
> > > Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> > > ---
> > > 
> > > Applies to kvm-x86/selftests (I chose that branch to ensure I got the
> > > MAGIC_TOKEN change)
> > 
> > Heh, and then I went and created a conflict anyways :-)
> > 
> > https://lore.kernel.org/all/20231129224042.530798-1-seanjc@google.com
> > 
> > If there are no objections, I'll grab this in kvm-x86/selftests and sort out the
> > MAGIC_TOKEN conflict.
> 
> Actually, I misread the patch.  I thought you were removing newlines, not adding
> them.  My thinking for TEST_REQUIRE() is that it should look and behave like
> TEST_ASSERT(), not like a raw printf().  I.e. the caller provides the raw message,
> and the framework handles formatting the final output.

Darn. I'm not sure how I forgot about the other TEST_* functions. We
indeed want them to be consistent. I'll reverse the patch. Also, it
looks like when errno == EACCES, test_assert() will be missing a newline.
I'll do a quick audit of TEST_* functions and their callers this time
around.

Thanks,
drew

