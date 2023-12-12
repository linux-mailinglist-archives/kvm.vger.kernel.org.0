Return-Path: <kvm+bounces-4221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A52FD80F4B6
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 18:36:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5AFAD1F2159A
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 17:36:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DEB97D8A5;
	Tue, 12 Dec 2023 17:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WoVNRF8X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EEA93;
	Tue, 12 Dec 2023 09:36:02 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-5d8ddcc433fso43019177b3.1;
        Tue, 12 Dec 2023 09:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702402561; x=1703007361; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AqYW6zWEA4DrVdtJ0M0uHwX0AZKuTGbkjdSNuNf9Jsw=;
        b=WoVNRF8XgvjVELlmulYULfD2xKLV+DTzhPLGN/vVXPZQMTzP614zexwKoNOGGKjWkk
         rX0U/s27DN9BAZYKd8jOC5OYfZwpWXoehkVHN4CvEY8fmP4FaDS8g0iDtowre6owgY5o
         zksrCP+6yNyyJNRcafXfC9WpFolCTTlD7R7EUdjO6bTNjc6hqZ0Bnky3/NUnd+l6Uw9b
         Xq1g3xVwrjRbv31rSFxF3aTNRAiu9RSOl8oUy0f8e/hodHnSi3dNBEDBqodfwoVvXxSr
         7+YvrdY6MrBK7FdBHmN0YUTz7MbQ9WHnyhcxKZHge4HneKOtc7Wi3EEjJp6WOR6odgVw
         2ggA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702402561; x=1703007361;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AqYW6zWEA4DrVdtJ0M0uHwX0AZKuTGbkjdSNuNf9Jsw=;
        b=HIXXa0LW2zNwFIetmj0XIbAjTB2xPSgwIDRoTSPR+Y+NIFrHBL8AhiiomM0DL5gii5
         rlPgurU6+dJ2JHGLBojx+82pX7hK9uYrmXQf3Z/lUdxI3iSp03L71zRpqDEayN5BQ9nb
         t9n4wLGpxFx7tryZg47lBMFcqdLYL5FBgkOzKbrz8Co6gc3Enb4u6HKdqyAviyyLcFa2
         Hvs7mSTtWlk0RgchQVYTN5ChoQio+DoJIM3BoAlzkaCntZdrRFTW50iC0zUiPFCQs+Fu
         QDQJGR+E0w8d/2xIpwmOnf95sZ0NL9pArfOBd7KEcFL53tBKFdS1vOUALmGPGNzy/tiQ
         W+Yg==
X-Gm-Message-State: AOJu0YxjE5rEQSbeL6bMnI/vWNU5t2FJ/F4wMtdlRJRCcwzaXbRkmotf
	T+V8IOTnWQHiaQzaCL9O2wU=
X-Google-Smtp-Source: AGHT+IE/2pSQ9yKqXyt2sZV+rUNwsE5JpJPh36RxwM+nVPxHryEkYXvEScysoA+RwrJAZ0UpUjbtxA==
X-Received: by 2002:a0d:fbc2:0:b0:5d8:d2b6:6266 with SMTP id l185-20020a0dfbc2000000b005d8d2b66266mr3054619ywf.99.1702402561267;
        Tue, 12 Dec 2023 09:36:01 -0800 (PST)
Received: from localhost ([2601:344:8301:57f0:38aa:1c88:df05:9b73])
        by smtp.gmail.com with ESMTPSA id o5-20020a817305000000b005cd9cdbc48dsm3897945ywc.72.2023.12.12.09.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 09:36:00 -0800 (PST)
Date: Tue, 12 Dec 2023 09:35:59 -0800
From: Yury Norov <yury.norov@gmail.com>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Matthew Wilcox <willy@infradead.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [PATCH v3 13/35] KVM: x86: hyper-v: optimize and cleanup
 kvm_hv_process_stimers()
Message-ID: <ZXiZ9XviH84mXPG5@yury-ThinkPad>
References: <20231212022749.625238-1-yury.norov@gmail.com>
 <20231212022749.625238-14-yury.norov@gmail.com>
 <ZXiW3AgIENf7whei@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXiW3AgIENf7whei@google.com>

On Tue, Dec 12, 2023 at 09:22:36AM -0800, Sean Christopherson wrote:
> On Mon, Dec 11, 2023, Yury Norov wrote:
> > The function traverses stimer_pending_bitmap in a for-loop bit by bit.
> > Simplify it by using atomic find_and_set_bit().
> 
> for_each_test_and_clear_bit(), not find_and_set_bit().
> 
> It might also be nice to call out that there are only 4 bits, i.e. that using
> for_each_test_and_clear_bit() will still generate inline code.  Definitely not
> mandatory though, just nice to have (I highly doubt this code would be sensitive
> to using less optimal code).

Sure, will do.
 
> > While here, refactor the logic by decreasing indentation level.
> > 
> > CC: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Yury Norov <yury.norov@gmail.com>
> > Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > ---
> >  arch/x86/kvm/hyperv.c | 40 ++++++++++++++++++++--------------------
> 
> This doesn't conflict with any of the in-flight Hyper-V changes, so with a fixed
> changelog, feel free to take this through the bitmap tree.
> 
> Acked-by: Sean Christopherson <seanjc@google.com>

Thank you!

