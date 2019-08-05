Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D878A81898
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 13:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbfHEL6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 07:58:22 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45586 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728056AbfHEL6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 07:58:22 -0400
Received: by mail-qt1-f194.google.com with SMTP id x22so7193288qtp.12;
        Mon, 05 Aug 2019 04:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Cf79lRbjTxuYvrjTYwQy5DclxuSwBZtPZCw1u1tZDjw=;
        b=MEROJahA3aFopIyauLYvf1B6zTAtFRQGVywLTvuOwy0JV4Azcl0Amnbxf4zUVIqC/G
         5kTOuNGsltVhyCAHagN0JycjpE1hWV9by85hkhO/e+7MOMdTir8envu7FOhORPmE+286
         Rrll9tSc18atKkAuKx4mDNGgcbTqwXWZzHoKEGJ9EBYA4Qu3jZJIZjuPs+D4LuugbDMq
         TMArjd+Kq+lMGFYUAQPDTWziIsUQLdTMdCJiL+xRYXHehHWHrlnDLvfUjCcu6lV7t75R
         CeJhw2oihej2DOdXP3Y+mMlHNT4OYC236xyTHU1Qpvtt/KG/LwaKs5PpyEP/H38MYFBd
         KujQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Cf79lRbjTxuYvrjTYwQy5DclxuSwBZtPZCw1u1tZDjw=;
        b=H1Kor2Oq7J3iEcqqwVl197sYp1OZNJGWvYFyFhKwPr+pMPtWUSL0UMAcOTHrOe8fUj
         a+0W46sGpadr/IBI+9rv+PW/n+Tx6A0KzDrMhC9615rT5P30vjS5dvwHVvhPn/vCR38n
         jWvLKv1do9YNSwHL9fAy455+slB3yKijJf/nu81NmdOoyUZo99VVBKPI7HUQD4ZkC6g9
         srlcC4AYkSzJLSFcV/gUKzwHBthWtpMvAr5Njt1Ui0DzZkuUNFpKbGypyVMTp1UhCkhR
         MOG+IGz/9aPnxgXMPGfGxmuSjAGddmJBAG7kRth3Kh8kJ0T2SfTXS3mIRk8vSVw4ffCO
         aIeA==
X-Gm-Message-State: APjAAAWY4rbzh5Asv5hCg/x7PmzQHJWJh0vq1X+ERfQjdeIG786As8Pf
        wuNFKnyV/SngKZQJ8Y+zGNE=
X-Google-Smtp-Source: APXvYqzR5O4gZkb0h8p/vmE0FqgjnI+i2nL2OnMMo6DdX+NKyxRyToVMerzJYx27wg9lgahrIR5eNA==
X-Received: by 2002:ac8:34c5:: with SMTP id x5mr101803128qtb.91.1565006300868;
        Mon, 05 Aug 2019 04:58:20 -0700 (PDT)
Received: from localhost (tripoint.kitware.com. [66.194.253.20])
        by smtp.gmail.com with ESMTPSA id e7sm34167209qtp.91.2019.08.05.04.58.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 04:58:20 -0700 (PDT)
Date:   Mon, 5 Aug 2019 07:58:19 -0400
From:   Ben Boeckel <mathstuf@gmail.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCHv2 25/59] keys/mktme: Preparse the MKTME key payload
Message-ID: <20190805115819.GA31656@rotor>
Reply-To: mathstuf@gmail.com
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
 <20190731150813.26289-26-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190731150813.26289-26-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 31, 2019 at 18:07:39 +0300, Kirill A. Shutemov wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> +/* Make sure arguments are correct for the TYPE of key requested */
> +static int mktme_check_options(u32 *payload, unsigned long token_mask,
> +			       enum mktme_type type, enum mktme_alg alg)
> +{
> +	if (!token_mask)
> +		return -EINVAL;
> +
> +	switch (type) {
> +	case MKTME_TYPE_CPU:
> +		if (test_bit(OPT_ALGORITHM, &token_mask))
> +			*payload |= (1 << alg) << 8;
> +		else
> +			return -EINVAL;
> +
> +		*payload |= MKTME_KEYID_SET_KEY_RANDOM;
> +		break;
> +
> +	case MKTME_TYPE_NO_ENCRYPT:
> +		*payload |= MKTME_KEYID_NO_ENCRYPT;
> +		break;

The documentation states that for `type=no-encrypt`, algorithm must not
be specified at all. Where is that checked?

--Ben
