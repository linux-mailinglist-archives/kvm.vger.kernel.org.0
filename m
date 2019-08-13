Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0D418B979
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 15:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbfHMNGf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 09:06:35 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44540 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbfHMNGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 09:06:35 -0400
Received: by mail-qk1-f194.google.com with SMTP id d79so79456110qke.11;
        Tue, 13 Aug 2019 06:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dPePM4b7Ly9h58EwlKTM619AD4xFQbyhPDiSia2EM2U=;
        b=rWi6khMGtrbzvWBFMuKOaneDwVBFkNzEA+bV4ShPlu9hL6T+L7nBa8gQDqbg7wmj9l
         A3KIk979T6sWVsHhW4Fm/VaENm/Pi3YN9D3TaMbA39C3bNT0UdMZbtzfgFwX8I773l/c
         3RsG9coxViRKwz3yQGebHYpzOEt6b6aR6vvSzsRAH3RbtDY1HDGaMX6ehk0FlP7sff7C
         ekZDrrVWdki+9s23mAN9i+bmtgZqgXojixJSkXBwq8Efoir2sZDaba3uPvCZhlRSyqIY
         CrG+1B1yVaV4pE4euqUVZufBvyCGY3HP9VT9vlaNLTbPJwVsmhEc0FPeovlP8bvtYcsV
         nWyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=dPePM4b7Ly9h58EwlKTM619AD4xFQbyhPDiSia2EM2U=;
        b=sjVgoJtOQC6LV+GCYC11N4l2aclNgYcrqCvAdkhufO6a3AYQ1uExjDwGrn6jT4f6AG
         FhjL+r3DalA2bOG7t70aVNbk0COJhCAZTMBo1ysA1w0AFxsOQfl87IY7JKcfR8LNyE6X
         VvEDQMWmnDKFyI0i2jZewY1+l1Q0kzub5Rs7ivKjSVehI2O1eiAMZIceA2ipfh9vB0C1
         yd9yI+eb9Pu/g7Lq3Yz2m46LvToLNLK+xbjvif36FqlFnwJBB4TzZhYTVpdAiaYjMU33
         It0UdwWmUPCICUASMh4pbuFo12z3dlCZHbPD/xnJCuV6FzBrEfe4c7xgElPufyiOM5bH
         k4LA==
X-Gm-Message-State: APjAAAUnKz4nQU3KhT1fFj92bBKR7HHzUHnUKz+4qHyEieXd2SI+zxVp
        zmwxbg0GQSKw7fhFOJ0NBmU=
X-Google-Smtp-Source: APXvYqxoPh7Vwka4FMUE4K0pxkSvpnkQ2+EVcB3voDPInyDih0g+8JHM7XendeivsUYRonHZ4s/q+w==
X-Received: by 2002:ae9:c00c:: with SMTP id u12mr23656206qkk.75.1565701594164;
        Tue, 13 Aug 2019 06:06:34 -0700 (PDT)
Received: from localhost (tripoint.kitware.com. [66.194.253.20])
        by smtp.gmail.com with ESMTPSA id z5sm45834363qti.80.2019.08.13.06.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 06:06:33 -0700 (PDT)
Date:   Tue, 13 Aug 2019 09:06:33 -0400
From:   Ben Boeckel <mathstuf@gmail.com>
To:     Alison Schofield <alison.schofield@intel.com>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>, linux-mm@kvack.org,
        kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCHv2 25/59] keys/mktme: Preparse the MKTME key payload
Message-ID: <20190813130633.GB9079@rotor.kitware.com>
Reply-To: mathstuf@gmail.com
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
 <20190731150813.26289-26-kirill.shutemov@linux.intel.com>
 <20190805115819.GA31656@rotor>
 <20190805203102.GA7592@alison-desk.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190805203102.GA7592@alison-desk.jf.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 05, 2019 at 13:31:02 -0700, Alison Schofield wrote:
> It's not currently checked, but should be. 
> I'll add it as shown above.
> Thanks for the review,

Thanks. Seeing how this works elsewhere now, feel free to add my review
with the proposed check to the new patch.

Reviewed-by: Ben Boeckel <mathstuf@gmail.com>

--Ben
