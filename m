Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68D64B38B4
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 00:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbiBLXqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 18:46:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiBLXqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 18:46:11 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB43E5FF2E
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 15:46:06 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id o128-20020a4a4486000000b003181707ed40so14918360ooa.11
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 15:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/AuSp8ivg7WSvQzgIOUag+vQH/4aNu10op8mIwRLJA8=;
        b=NuuQiuhdYCj58R+uAgFQxEEpqNvH01CX9GbQSym/6zNyPelJv5JmimHH3Uy1FR9Z16
         v6L8eYHrYrRs7ezYv9Sp62q/cnL/Gef4vaoQwQcI7i2oy8CYDirDivdZ824+fSpc9dQp
         eSKUwKW6wFmxaZUFQLvKXdb99hH7JA1wFuUJ0ttj5XSibuKndasHqN40ZF3+8BLhLfE+
         Uba+oSiJli8LwRCdbM56TcPMTjclN7E2OzDTvBuNo2GdHVGQ/y13Awush+k6CiefK+LU
         ZjvNgbgNbl5NGyUc/6U/2WMtJXN4o+R+sO1UeHNtI0D/uPM3UJPLFYgAxdZwauquMMkg
         iAgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/AuSp8ivg7WSvQzgIOUag+vQH/4aNu10op8mIwRLJA8=;
        b=QqqfHM4VqpjZCYmbSmYvG8rlfjqmlM10oWIksyCaMCZKEHk+kIWp5r2F7TTHj+YaAD
         5mfteoEhzBtnNCs7Jj94DDb11AjLAsLaoSe/tBIt/5QGWKpy84c3UJJa2k/XN3po+SM8
         PaQmV4GlatIkNjOzT2AREAyNDq87uhiGvtic8FBzUYmDatXhMuM+TxQpcQ5Dz8xhsWGN
         E1hIMPZo+Eun0sMFU1X/j3S5P6daRoYvhYCa+Ss1F/sGYMx5Qz6/GNRThpWRMTxDFiW4
         2fCTWlbekp27yUWmw73sH8leMMD/wMv8Qixw+nS26I3cFhicm+zAgO4OlUJB6NBQYEzC
         1DGA==
X-Gm-Message-State: AOAM533I4Y21AiE/pWrPA7C/2FLVLE73hTroE5YdbGXfpM+z03lEaUwA
        jVmDgR6HCbUQF5rOO3JSaI/L6BJOfoVZoFUR8gDQcQ==
X-Google-Smtp-Source: ABdhPJzKSTstMyKd4/f5iVPVmRnGOfOcXyfH371JrIwGJ7TbLnKEaoKZFtnWBnTZ+D0g15Y8VG4RsbcSYLuxQmSkuF4=
X-Received: by 2002:a05:6871:581:: with SMTP id u1mr2077984oan.139.1644709566075;
 Sat, 12 Feb 2022 15:46:06 -0800 (PST)
MIME-Version: 1.0
References: <20211116105038.683627-1-pbonzini@redhat.com>
In-Reply-To: <20211116105038.683627-1-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Sat, 12 Feb 2022 15:45:55 -0800
Message-ID: <CALMp9eRF59cXP1+ceTwsYVa8ny3NF_TOPqpprhH7veVzTCD2HQ@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] pmu: fix conditions for emulation test
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021 at 2:50 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
...
> However, the pmu_emulation test does not really need nmi_watchdog=0;
> it is only needed by the PMU counters test because Linux reserves one
> counter if nmi_watchdog=1, but the pmu_emulation test does not
> allocate all counters in the same way.  By removing the counters
> tests from pmu_emulation, the check on nmi_watchdog=0 can be
> removed.

If Linux reserves a counter, shouldn't KVM_GET_SUPPORTED_CPUID remove
that counter from the available set reported in CPUID.0AH? On Intel,
that is. On AMD, we're just SOL.
