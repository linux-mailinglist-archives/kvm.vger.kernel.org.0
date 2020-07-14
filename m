Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB69B21E704
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 06:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgGNEh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 00:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgGNEh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 00:37:26 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03832C061755
        for <kvm@vger.kernel.org>; Mon, 13 Jul 2020 21:37:25 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t6so3337262plo.3
        for <kvm@vger.kernel.org>; Mon, 13 Jul 2020 21:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0qdqXaqZyPmuL903QQCWfrJTGFMRDZfw3756dMo+QfU=;
        b=JRiJdPHUo9vGJ+xPfld5Km6Dgh60r4reryXmAb5MVAGSuHIbR14HUxYlgPr26TRUPL
         68OIbEqjhlmqmQmf65/vD88yCBsqmuRRAk9LaXZcVSOxRq4ffNm7cBC+a3JiZ8rY+1D8
         7zyPfTjdloHE/6VvykDBarLVIaRQGNm/BM3sGeHhwRYUxfP2BDDAiQQAiSO2yOpN1PWQ
         e6ATFeppZkRwIiSdPidAPILAE5FMJO7AYmFW7MpO/xTcdW3xiBKiM7RfW9fkgp7xlv6R
         2IW8m4CfBfp5CpK4XzaYL/TPRpdkn5itC9gaOsubkRfscMTenfREvxpt+Ta0j9bH0UD+
         AOAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0qdqXaqZyPmuL903QQCWfrJTGFMRDZfw3756dMo+QfU=;
        b=mNLNi0gPW5oA8BminnIWTc+gNVhiSQq83Tjr7Hw6xngFxp/6G+wGwQljCJTyaOEPhT
         uFXL9wzDfm8L3pmbtbKy/bokrah3KR5j16wQl47OJOmMRThVQLJySetXviXAJn4625FQ
         xjjgBjAN5ig+mdfXaSYoQiDkCYh0I5c0p7hGb14mV3TXsC2bXe5YQ4UJjHilsFuH8uFF
         /4gHeCN6AG3Rs2r39nDdkvrLolcAHv3AwIgeU4Ztjc89V1vxUceySv+eGlA4X2tRXOGR
         0Y0WhvVq9cidkE+KO7rURxmcYdDnhRfXsthZvqNxsBStrnG48XZKfjz2pGUdwxQrTshO
         TkBw==
X-Gm-Message-State: AOAM530ZzZYipb7HDlc2VzZSmrcYIV4+YiCcusbvSN2ByEJQp+OlLj6N
        Xf7DQ1UE00HZhwAaYbdt/SA=
X-Google-Smtp-Source: ABdhPJx7oYf86wBIM6WfWVTcYatdly907/fBsOt3ALFUo4yfZt9DlvNpUOylyyvATrXXWh1XqgZDYw==
X-Received: by 2002:a17:90b:33c5:: with SMTP id lk5mr2714104pjb.181.1594701445282;
        Mon, 13 Jul 2020 21:37:25 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:c93b:d519:464b:6d2e? ([2601:647:4700:9b2:c93b:d519:464b:6d2e])
        by smtp.gmail.com with ESMTPSA id 16sm982370pjb.48.2020.07.13.21.37.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2020 21:37:24 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [kvm-unit-tests PATCH] cstart: Fix typo in i386's cstart assembly
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200714041905.12848-1-sean.j.christopherson@intel.com>
Date:   Mon, 13 Jul 2020 21:37:22 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <AB5EF337-A271-4440-B716-BEB4AF70F5FB@gmail.com>
References: <20200714041905.12848-1-sean.j.christopherson@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 13, 2020, at 9:19 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> Replace a '%' with a '$' to encode a literal in when initializing CR4.
> This fixes the build on i386 as gcc complains about a non-existent
> register.

Reviewed-by: Nadav Amit <namit@vmware.com>

( I should have noticed it before )=
