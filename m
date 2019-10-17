Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20374DBA24
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 01:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438560AbfJQX2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 19:28:08 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:45550 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389107AbfJQX2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 19:28:07 -0400
Received: by mail-il1-f196.google.com with SMTP id u1so3784365ilq.12
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2019 16:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=knIyjHcpjILq0/zpZ6OZalQq3rfrC9s7MFS9cVXlUxk=;
        b=ShxvTb2Cdfz4oDjazG1PuzFbSf1ZBe4wP+qLRdPzbXu204+Pi4ufV3rFHgKmITPJOU
         VrNJIS13rxzDesKzunlVg0t+rEKeHKHtYdnIVq9fXrwf6qiKy0ev7moplAoKGX/67bUC
         IDL5aag/70PmBLzDUmAFW/vShShERL/3lBj3VIj0k/4QkD3ap9DTq1oulBaQ4ayE59xm
         VGchi0IqSneotxgEAV/Lsp4EFzNhbENzgronsWtrzywvBSr+hdzLXl1b9ytzTxtemGaA
         zf0x9CzOUML2/NGpLuZnG9QTaZT2VsQ1nZ0u/04FO7RAbLL4x9LTQh+6fwm7u/Oa1OMZ
         E6Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=knIyjHcpjILq0/zpZ6OZalQq3rfrC9s7MFS9cVXlUxk=;
        b=Fdzl2adGxzdDW3ftgI+IFbQOc1Z+5ctqV+pO1cJATN3qOOO1+pJmy6OVEryFbP+k/1
         yzvczcm+Yw8BWNmwYAVxKIJl1MtUr2cKdO/Thvkak2swKVMKsAhSz48PXFgtqSaFLmIA
         BXTGAoIIhAnbgKqD8/jM8PfHlJPN6URaxFwq1UpKxeAa1B3UyFxSe9SDAKD//s0LSl0j
         Z0hi+77tZcDTJEE2s5MiziPZzsYEpVkndD3xdyQUPyvrX6rpfcGXd4fdtYAi8GtZj0wG
         RmpFSSCfwGqvgZWzF68Kt+Ewb5UvbZ4halQ/zKmrMaTfDt+eHXIeVCzOGmh5V0eunN8X
         mMIA==
X-Gm-Message-State: APjAAAUanV2oOzrlC7m2kF0g27Nk2Fsiy0KQUkDl/C9qqLZ/m6TfZ2WB
        j7MUGaabFMpzhUFxgFwKYz67OAcgVmTkijcC5Si68Dbd
X-Google-Smtp-Source: APXvYqxnLqc7zUW9IGAGqlF9gbtpweq8rLwg8vtwZXpMLIsA2qLYlQhQyrhhEFfQd1YBCeaR1ME4ICljyATtKA8kodY=
X-Received: by 2002:a92:ccd0:: with SMTP id u16mr6948889ilq.296.1571354886596;
 Thu, 17 Oct 2019 16:28:06 -0700 (PDT)
MIME-Version: 1.0
References: <20191012235859.238387-1-morbo@google.com> <20191017012502.186146-1-morbo@google.com>
 <20191017012502.186146-3-morbo@google.com>
In-Reply-To: <20191017012502.186146-3-morbo@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 17 Oct 2019 16:27:55 -0700
Message-ID: <CALMp9eT5NEdaihe31ZmmWHG8H=jNH9OeesixQw21_=YYq6p=8w@mail.gmail.com>
Subject: Re: [kvm-unit-tests v2 PATCH 2/2] x86: realmode: fix esp in call test
To:     Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, alexandru.elisei@arm.com,
        thuth@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 16, 2019 at 6:25 PM Bill Wendling <morbo@google.com> wrote:
>
> esp needs to point at the end of the stack, or it will corrupt memory.
>
> Signed-off-by: Bill Wendling <morbo@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
