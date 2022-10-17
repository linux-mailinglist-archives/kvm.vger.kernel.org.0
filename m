Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435BF6012AA
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 17:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiJQPXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 11:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiJQPXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 11:23:01 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AC122295
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 08:23:00 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 3so11403158pfw.4
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 08:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hb/glNebN2b268828iQDnNaHbmvSFiccqcWKdCSNag0=;
        b=UuetnD/P3zIId7jki4JMC1L+AOG00b4PMGn9umVm3L971I2JWZrpNBeJj7oJTWy5yk
         CuVZGt2t+0bDWgNxWHWXA7xRpAoF49KutS0Y0ctSdh2f0mnPFRf/HKzTymhGtyqrtmXi
         hgfemINK4cRtI95IqRY0J9BGmsd/B9o+BBxcUvpbI6PAOZY017jAehKI8Gtar3hRDnLT
         x1JzZPr57OdZihplXzNk1xDPZKzGNr143o6eBMCFHv1tn5yXUsdhzknKylToMShmJdTX
         jQ/A8cGmN7+yM2nM4ia4IUXvbKFjRQS58q2RsLD8pgYZgMhp9OBUfkx4ztHjdj5+VZlI
         xhVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hb/glNebN2b268828iQDnNaHbmvSFiccqcWKdCSNag0=;
        b=THbjBmJTXnvqMAV8XwtAHhwkKOrc0fRF8xrrhw3nBq/7N/VSW4nIToxyBgdgOq4mnD
         Cz8/YnpMalfUfLQKa446rfjWajnODG+J2o1jRyAV/mtT0JQdo8RVDHQJlS7YaYrPApD5
         vPtfucODxC3fPkd+rw7IrQVbIpfVrvsCDbyqgAxEvzbwkV7EbD0pjq+ymeuvLYfua9vB
         46E+jQo3mrv+WOpidk7Dy4sG3jcHLwrzeGjErAPuFEEfoMdbeAIUzJ1Gol0lwSxWemCa
         IukUbc2XcHEm28gLRwHuWzESR/JBadMcGJBvJyRBUvNP7k1Z6h0p1kIgRd+gPMYQ+nLF
         vOUw==
X-Gm-Message-State: ACrzQf0T6ZA+DT8htSs4VayLx00iDIEdeQBA0bU6u5l3EHhgu183m93V
        t2A3HHCptqX5fU1f8autso/bfzKODyWKkA==
X-Google-Smtp-Source: AMsMyM6I3HVP3zWIjbs2IkwvuZwjcaeKbAeDhkqjQqP0pG6ddu6jl6roIbCHvQqIUuT9ZvKFTJjphg==
X-Received: by 2002:a65:6e89:0:b0:43c:e3d8:49f1 with SMTP id bm9-20020a656e89000000b0043ce3d849f1mr11220395pgb.315.1666020180308;
        Mon, 17 Oct 2022 08:23:00 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a8-20020a17090a008800b001fd7e56da4csm9808013pja.39.2022.10.17.08.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 08:22:59 -0700 (PDT)
Date:   Mon, 17 Oct 2022 15:22:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     bugzilla-daemon@kernel.org
Cc:     kvm@vger.kernel.org
Subject: Re: [Bug 216598] New: Assertion Failure in kvm selftest
 mmio_warning_test
Message-ID: <Y01zT1QcDY3+5iwR@google.com>
References: <bug-216598-28872@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-216598-28872@https.bugzilla.kernel.org/>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 17, 2022, bugzilla-daemon@kernel.org wrote:
> Created attachment 303018
>   --> https://bugzilla.kernel.org/attachment.cgi?id=303018&action=edit
> ==== Test Assertion Failure ====
>   x86_64/mmio_warning_test.c:118: warnings_before == warnings_after
>   pid=4383 tid=4383 errno=0 - Success
>      1  0x0000000000402463: main at mmio_warning_test.c:117
>      2  0x00007f5bc5c23492: ?? ??:0
>      3  0x00000000004024dd: _start at ??:?
>   Warnings found in kernel.  Run 'dmesg' to inspect them.

Known bug.  Fix is posted[*], will make sure it gets into 6.1 and I suppose
backported to stable.

[*] https://lore.kernel.org/all/20220930230008.1636044-1-seanjc@google.com
