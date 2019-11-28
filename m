Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E81810C521
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 09:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfK1IbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 03:31:11 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43883 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbfK1IbL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 03:31:11 -0500
Received: by mail-wr1-f67.google.com with SMTP id n1so29996191wra.10;
        Thu, 28 Nov 2019 00:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:mime-version:subject:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=41iFNzsZShp3cTI5whXr8wJxyzr91hsxklxwLQF/D5A=;
        b=TK91N00lx4mZdugbyv2Ejmsi3NeRlCtaW7zEma2yjbWiRGE7/1cDbjaXwzSE57ROBG
         n+zhGhgmB/dw5P0ZlYepLDRTMVHYagELsLWNPyzZ+FQKY5sGSNt6EiDSG+a/TIuIkbsZ
         ggEOtJYK86VyXwhyGF251InPCJlLeTnzcsP5Rqo4TnemjWtt02lax45HMDYJfJuJrCt3
         +9Jxq6esNeQ6pJeggH5+YwvwsujhJLxacEQaWJxIbdx/2S7rsHkB/LnXK33adX51IjYg
         8bTMqv3cJp8zgxggGW7GJmDTW6I9Dj6+/TXUTa5+cgZ6cqEHdsEQb0R3X22zAqGGxjkL
         AGbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:mime-version:subject:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=41iFNzsZShp3cTI5whXr8wJxyzr91hsxklxwLQF/D5A=;
        b=kM18Nx2cM8j7zZja4xOdJdK8tIFTHtaLYHWoWzrSlExO1wpkDmCLUcVSY3P0cIq/qq
         IaQ0PBg4nEcwRikF05cAUMKhQB/ENnWwlF9M0We1syokI2aaKbWCM/Yfd9aOjpA0diZP
         KHxdOo43ZyYJq+50nRo7JLEeXhHAwYHGsyhwQZmNQYm5TjhR0ME+mGlBxJbq/u6yQvOW
         VaWw7ljiHSTsSbuvNcN6NP4mtmzKe2+QMXp6qBoCj01kuPtqC8lmVBcXhYRmu70zuP0r
         V68zZtoMKIMJZqUfrHeFHrRoo2jItO2/C5hHl5JUq3aSGvtp0L+WW+pEs5FQArE9VtkK
         XmAw==
X-Gm-Message-State: APjAAAV7GQ8oRBDNLafWt/Cb4nFG7o7rf9ohNhbCEzXb5WDIcdHUOB1U
        hqFCUCihAkQ+QdSNobaM3Uk=
X-Google-Smtp-Source: APXvYqxXk8FwSRUAiGCAnDZ0aIrVLk/2gHjGzrhjZnH1HsSMGh7kpX1+8dGo4cWeqmbSasTT77Pl0w==
X-Received: by 2002:a5d:5050:: with SMTP id h16mr50519725wrt.380.1574929866906;
        Thu, 28 Nov 2019 00:31:06 -0800 (PST)
Received: from ?IPv6:2a01:e0a:466:71c0:d4fe:9901:8a9f:19cf? ([2a01:e0a:466:71c0:d4fe:9901:8a9f:19cf])
        by smtp.gmail.com with ESMTPSA id 91sm23455974wrm.42.2019.11.28.00.31.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Nov 2019 00:31:05 -0800 (PST)
From:   Christophe de Dinechin <christophe.de.dinechin@gmail.com>
X-Google-Original-From: Christophe de Dinechin <christophe@dinechin.org>
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH 13/13] samples: vfio-mdev: constify fb ops
In-Reply-To: <fc8342eef9fcd2f55c86fcd78f7df52f7c76fa87.1574871797.git.jani.nikula@intel.com>
Date:   Thu, 28 Nov 2019 09:31:03 +0100
Cc:     linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        ville.syrjala@linux.intel.com, intel-gfx@lists.freedesktop.org,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <39B62C70-3E60-48AB-8F11-534EF5B8EFBD@dinechin.org>
References: <cover.1574871797.git.jani.nikula@intel.com>
 <fc8342eef9fcd2f55c86fcd78f7df52f7c76fa87.1574871797.git.jani.nikula@intel.com>
To:     Jani Nikula <jani.nikula@intel.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 27 Nov 2019, at 17:32, Jani Nikula <jani.nikula@intel.com> wrote:
> 
> Now that the fbops member of struct fb_info is const, we can star making
s/star/start/

> the ops const as well.
> 
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> ---
> samples/vfio-mdev/mdpy-fb.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
> index 2719bb259653..21dbf63d6e41 100644
> --- a/samples/vfio-mdev/mdpy-fb.c
> +++ b/samples/vfio-mdev/mdpy-fb.c
> @@ -86,7 +86,7 @@ static void mdpy_fb_destroy(struct fb_info *info)
> 		iounmap(info->screen_base);
> }
> 
> -static struct fb_ops mdpy_fb_ops = {
> +static const struct fb_ops mdpy_fb_ops = {
> 	.owner		= THIS_MODULE,
> 	.fb_destroy	= mdpy_fb_destroy,
> 	.fb_setcolreg	= mdpy_fb_setcolreg,
> -- 
> 2.20.1
> 

