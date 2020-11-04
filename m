Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1892A6F4F
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 22:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731103AbgKDVAL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 16:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgKDVAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Nov 2020 16:00:11 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11846C0613D3
        for <kvm@vger.kernel.org>; Wed,  4 Nov 2020 13:00:09 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id p5so31814879ejj.2
        for <kvm@vger.kernel.org>; Wed, 04 Nov 2020 13:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E4WjwvX76hWxO/jjnNrz+gLq3En9lQGeWplxRyxXQHg=;
        b=j/1V9bssxmEIreRGcTEqx+rkllCy0rb8iB/heFAS6Kx3kHYt/HjNn06hQ3gTiUZeO6
         OKFsujIpjX5Qo391FcbJBHDvVxnpp4oAU+Vhq+iLeLg4wu77loaiVvYYFgz63D+me5ZI
         lL3JwsImAVvnw20KMqZO6fxf5DpJEScEJ/edT4RoYCVAJ0WPf5OS+6dadl28Pp0/O+DV
         KicnqQg/bENuJ0y537NtKFL421LKSSW4t0ZVBqhULvmBJ9Cjkv6BQaVVKfWKAA2c89Op
         b5b/4eJjxFs8YB4GUSIM98Js1jp3A5Q/YUy4RqQA5gMrIHQ+lWnmCJVLTv2Lf/qKHYfn
         XaZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E4WjwvX76hWxO/jjnNrz+gLq3En9lQGeWplxRyxXQHg=;
        b=E9bny9VvvDyPDuiXKAmtxnbFhmhOfgDfNbBKHDY+SQ6DlkhtQBd6F9xlqFFKn5dQnB
         X41tBQI/Wr/Zxc5CThDUxMnDtF60gMOommFjvu2w8FFEKOG5LEnyXMO8u8G1UbJVBgZu
         gy1f8VwD/MSyw68H0zUaD53ZpA4VDBsBlrZyOJkGeRdukaiV7rQ/GJEOoIrlPXdbuhbM
         AYg9dyiJfdyWk2dkVxK9zLLMw5xSjSBGj3/xEN1l1RV2Nohu8HgGr3MIJR/crl7GI6h4
         mpGNGLq7Etg1WAdNDlY3EZL2I+qu2JY2vInrRMS2CcRBzhtviVqQHQrttdV0la21v5/O
         WGzQ==
X-Gm-Message-State: AOAM53082hzTYBfEYAoG7U6AKrr3pEfiuP6PU/fVLk2pDHUeHVkh9vZ0
        cvkOiPQBm5ebdiJTkNVlhWTZodj0diUnCYMx6BgilA==
X-Google-Smtp-Source: ABdhPJzTp3ZvGYQkhhsdlGrNNSN9lhK9dRQ4wLobyY1Aeai2n/vmogGkkpRzAx2U+4v/8JmtF2QZ9zlKDATyYySlwnM=
X-Received: by 2002:a17:906:af8c:: with SMTP id mj12mr25926268ejb.85.1604523607720;
 Wed, 04 Nov 2020 13:00:07 -0800 (PST)
MIME-Version: 1.0
References: <20201104151828.405824-1-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Wed, 4 Nov 2020 20:59:56 +0000
Message-ID: <CAFEAcA_fer-r6tJLRgQwQ+X1bAe0ODSA5UNWxZbSCtS1VHDO9A@mail.gmail.com>
Subject: Re: [PULL 00/33] Block patches
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>, Fam Zheng <fam@euphon.net>,
        Keith Busch <kbusch@kernel.org>, Max Reitz <mreitz@redhat.com>,
        Qemu-block <qemu-block@nongnu.org>,
        Kevin Wolf <kwolf@redhat.com>, Coiby Xu <Coiby.Xu@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Klaus Jensen <its@irrelevant.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 4 Nov 2020 at 15:18, Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> The following changes since commit 8507c9d5c9a62de2a0e281b640f995e26eac46af:
>
>   Merge remote-tracking branch 'remotes/kevin/tags/for-upstream' into staging (2020-11-03 15:59:44 +0000)
>
> are available in the Git repository at:
>
>   https://gitlab.com/stefanha/qemu.git tags/block-pull-request
>
> for you to fetch changes up to fc107d86840b3364e922c26cf7631b7fd38ce523:
>
>   util/vfio-helpers: Assert offset is aligned to page size (2020-11-03 19:06:23 +0000)
>
> ----------------------------------------------------------------
> Pull request for 5.2
>
> NVMe fixes to solve IOMMU issues on non-x86 and error message/tracing
> improvements. Elena Afanasova's ioeventfd fixes are also included.
>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
>


Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/5.2
for any user-visible changes.

-- PMM
