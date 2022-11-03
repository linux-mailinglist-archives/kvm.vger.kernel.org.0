Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132A26184D7
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 17:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiKCQiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 12:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbiKCQiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 12:38:00 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4997C1D0E7
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 09:34:53 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id v17so2455800plo.1
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 09:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2yxvjIIi2dXbGcou9/sNiB+yno6VxTJVUbDKB1g227M=;
        b=L3G9UPDtfd8hwCM8egD7isvedSafmxAEmgvHULsTU34upOWz8cY1C+gn2/mWsQSL/s
         maqfOLrzkQP+Jo/OPLEVnf317uMrGFdlumdY2czE9sbaeVOE1EK7RCJp07KSZE8Tiv7/
         votW1b1CJZMcbGeQ5SYva43TSFowat1PG7h2EErqU5xcVQ0vDrzPVXNpXwiJVJRXLdhB
         W+/VBHDt9mVCaCto96XmE+tYq305gO/KOJgwroCTgLxAyNn9s086lD1nSOOad3m+39SM
         ds5HMEIqPc9xDb0jjom9kcdLE1xswK+uC3Bt9x74q3STqB6ftI7iq1SAf75EZRB8io3q
         LJww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2yxvjIIi2dXbGcou9/sNiB+yno6VxTJVUbDKB1g227M=;
        b=QrxlO+wL8Az4YbMj33fy+RXT5EBzGVOEFeOTPn0eXf4LjO9hgTB2d2CMmHfJcU7XLj
         oWlC4cfegIzRpwarTeJpvAjFkLU0qYJVOIQQCqZJxTkqH/5WHf1ytYHFvP6GtJehJm4i
         J+ANYAY0QWrv6UQme1wjBhmG3N6Fl2SYV08m26YNLngJ3XUwpPtNcPHQRoq988O5CCN4
         koAenPcw4h6NIcNOTUv6eBcsM1/ReQezSBFjpRq07UrYnn/qoPczJ6zZ/MKDHfo07NQG
         L7eORrciGtyC0XfhlfuCH5P7J/DzxEsy/z7vv8uyBS49r9m7T97P6675Xh1uB/bx68OW
         +J7w==
X-Gm-Message-State: ACrzQf3EIRZNwMejQUtpNITejEG6CYbTSDuruMd1YnD4Z5b79OBhfzwu
        n8aLGihyCi9Zl8V2J7mGhgI+UA==
X-Google-Smtp-Source: AMsMyM62u2KHWJcgF9/WgB5CPvAZ7GrgiWc89nHyYK50ZNPNfmZLx9zV55xwsdWLYfdnKGtv0lT5og==
X-Received: by 2002:a17:902:be16:b0:188:5256:bf79 with SMTP id r22-20020a170902be1600b001885256bf79mr4502675pls.133.1667493273950;
        Thu, 03 Nov 2022 09:34:33 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id z23-20020a17090ad79700b0020ab246ac79sm167989pju.47.2022.11.03.09.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 09:34:33 -0700 (PDT)
Date:   Thu, 3 Nov 2022 09:34:29 -0700
From:   David Matlack <dmatlack@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v9 1/4] KVM: selftests: implement random number generator
 for guest code
Message-ID: <Y2PtlfbdebGfy47k@google.com>
References: <20221102160007.1279193-1-coltonlewis@google.com>
 <20221102160007.1279193-2-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102160007.1279193-2-coltonlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02, 2022 at 04:00:04PM +0000, Colton Lewis wrote:
> Implement random number generator for guest code to randomize parts
> of the test, making it less predictable and a more accurate reflection
> of reality.
> 
> The random number generator chosen is the Park-Miller Linear
> Congruential Generator, a fancy name for a basic and well-understood
> random number generator entirely sufficient for this purpose. Each
> vCPU calculates its own seed by adding its index to the seed provided.

Move this last sentence to patch 3?

> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Otherwise,

Reviewed-by: David Matlack <dmatlack@google.com>
