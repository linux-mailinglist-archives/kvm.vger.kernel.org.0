Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00536E1EDE
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 10:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjDNI6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 04:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjDNI6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 04:58:37 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFFE1984
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 01:58:36 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id fy21so945600ejb.9
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 01:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681462715; x=1684054715;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pIdy3f4aTAgiTGlWqm2BRv4SV4w8CG2bmwQTnc3YL30=;
        b=NCctQiifkVhkP4cNfSKHrv3k0HTpziuE5pxeIKT66xPGNMd+U5CCUX+wBkrCdKvbKI
         h6tEnd1yrgoUmqzbmiXijnKxrkcDBOVoXLuajpzSb0DZ7hYoK+hCJf+I7gzsPdrq4Vc2
         f80GHDRjpxoC5VwtEhrKE1ltAqR056A3gUN8SZaV3lVDRrhmDBDzT8wKedlZQDYaFNE6
         KRDf5AGWKt6ojVX6KaWqrJPK0ifWLNeJEvKi2mZcmXKZAqZ6O96qDtl37Dmxhwxqiwxb
         cZAx4nA1sD0/3orF8B+LsPs/ahS7B/tQQR2bT0WgMAnruru6AOeLmIVu//3Fzs4EJCcn
         pOhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681462715; x=1684054715;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pIdy3f4aTAgiTGlWqm2BRv4SV4w8CG2bmwQTnc3YL30=;
        b=LceZ9MUS6+uEscI02eIvj+rvUIS7ryZ0tuzXhFxMOneVBArYRAy/kdQOZg5PN/7x4h
         VePjfknZbiqXxzp59VBTIJTkOCv0DGpS/MJvDuI1KAhc6TlUKpk8TI4GFPvKIlNEI9uR
         H5YuCqxX0X2F8JtksI1nhitFI6qVEBNUeas09vshU+G9f3gp1Y0eaOwxpc3BpS8D1qcV
         oePSKB62RqFYUhsC8C6bS13WwjCMynNjdiYzw/5MHq+1jT312YCeHU2mWcz3mqYmed5L
         TJ3BoK8FXbfi9qMSEaoFnaYXEX13B7wVSdahHAUyccfG8VW8rqFE3z1u0dTDBLXw2XyF
         ljGw==
X-Gm-Message-State: AAQBX9fv8JT0ekXX1urVxsNFvHiDebhQvPet/FGvlPLW5jxHgzA4GPFd
        QHtThiNLn2GJYKCu+JX2Cu9BxczDHL+N6oyqwQKdtQ==
X-Google-Smtp-Source: AKy350YaoiYabb/11W8R9Qz0iahehyUySjcip1P8HZlC1+kvNHd3SFMviKQLEwoCxN/5s5DhWLfJRrB5o3ZA+q64WhE=
X-Received: by 2002:a17:906:edcb:b0:94e:c630:564c with SMTP id
 sb11-20020a170906edcb00b0094ec630564cmr1680631ejb.6.1681462714823; Fri, 14
 Apr 2023 01:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230413214327.3971247-1-jsnow@redhat.com>
In-Reply-To: <20230413214327.3971247-1-jsnow@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 14 Apr 2023 09:58:24 +0100
Message-ID: <CAFEAcA_gQ=kj4UpxAhWPVsVng-3+i9bOjkXyYk8snCKmrFUMyg@mail.gmail.com>
Subject: Re: [PATCH] tests/avocado: require netdev 'user' for kvm_xen_guest
To:     John Snow <jsnow@redhat.com>
Cc:     qemu-devel@nongnu.org, Beraldo Leal <bleal@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Apr 2023 at 22:43, John Snow <jsnow@redhat.com> wrote:
>
> The tests will fail mysteriously with EOFError otherwise, because the VM
> fails to boot and quickly disconnects from the QMP socket. Skip these
> tests when we didn't compile with slirp.
>
> Fixes: c8cb603293fd (tests/avocado: Test Xen guest support under KVM)
> Signed-off-by: John Snow <jsnow@redhat.com>
> ---
>  tests/avocado/kvm_xen_guest.py | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_guest.py
> index 5391283113..171274bc4c 100644
> --- a/tests/avocado/kvm_xen_guest.py
> +++ b/tests/avocado/kvm_xen_guest.py
> @@ -45,6 +45,7 @@ def get_asset(self, name, sha1):
>      def common_vm_setup(self):
>          # We also catch lack of KVM_XEN support if we fail to launch
>          self.require_accelerator("kvm")
> +        self.require_netdev('user')
>
>          self.vm.set_console()
>

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

thanks
-- PMM
