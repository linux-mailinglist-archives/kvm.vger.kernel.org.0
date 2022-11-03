Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEAD5618473
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 17:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiKCQat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 12:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiKCQa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 12:30:26 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A34167E1
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 09:30:25 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id h193so2097339pgc.10
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 09:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ngsq5i7P1ynqCbAbEUVhEQ+6ew8Ms4+d2FE5TkkRNWE=;
        b=THe8tR4AteqL2E1XjQ/21x08y5LpAMmKQzPQ3clO/JiPOUFV/AP0VO5wDA4fCjkoTI
         3kb6/OtulsxPXY0z0pIInk7wXip7dOdCtWMnbVzg2bI/y/BTsO+jsmYaCevtIu9ka+rP
         XX+3hbTimqb/zT4xLmJG5jkJDPTc7B7HydAR300NBIINtD9c2we8T/8RgN+K0vpuKlfZ
         zQgLd6LhYQhacGAh4wluXiCNmB/ijLx+uy/r9DKdpwipUtICcRrce09WZ9aotFepUDNm
         7rnzcIs1+19tAwgAGqVp3G7a1fVJd34FusYTCFUx5PVL3TfK3tZEheDuuyLDUFoXVxw2
         fdiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ngsq5i7P1ynqCbAbEUVhEQ+6ew8Ms4+d2FE5TkkRNWE=;
        b=g/AGduLul4pzXMGhtCCP0zvYSfd6j7HcUDw4IVltRd1YXAm6wPirOTNBdX8vUhGzPM
         TpNC0CmnSfkRtrmCyjgCWYjD4hW8lbEE5ZQzXbQkz7v0I1Xpt0moipM+1wmkAaZr4B1W
         pbEyy8aAf8u6M94iE6c8s/8+ypO9U9p/diUj9RY+yot3px/axz6JHiocDmgo7Ofs3rcl
         kK00M4GYXHgTzeOcS1EKp8/qCngjuoRn2DjeSX5vse8bw8PSvK4CyKbTZlZcQkKgzedU
         uAfGbQYC3d/uxBYuRG0ZSoTL0zmCHbvFIUvfjp1OPANqpt9LkeIQ6ur28cOOeeQ0N3vR
         AmMw==
X-Gm-Message-State: ACrzQf0Qk7QzaPyP9CLn1zPDcSRWSqOLTvetoycz0dQ85jbyNbySTcm8
        rkj3vdSLfjPncbgkYJ0QmZH+//JH1kZ4PA==
X-Google-Smtp-Source: AMsMyM6LyuxYs0WgJeaKlO1dgZRcaobJXakVR2KsLricOBIyUGuNNaTRgIEX+fu1Nfr0do/0ls8grg==
X-Received: by 2002:a63:2155:0:b0:455:7b5b:c2d7 with SMTP id s21-20020a632155000000b004557b5bc2d7mr26609780pgm.309.1667493025126;
        Thu, 03 Nov 2022 09:30:25 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id p12-20020a170902e74c00b00186fb8f931asm856236plf.206.2022.11.03.09.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 09:30:24 -0700 (PDT)
Date:   Thu, 3 Nov 2022 09:30:20 -0700
From:   David Matlack <dmatlack@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v9 3/4] KVM: selftests: randomize which pages are written
 vs read
Message-ID: <Y2PsnAGvwyd0BW6K@google.com>
References: <20221102160007.1279193-1-coltonlewis@google.com>
 <20221102160007.1279193-4-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102160007.1279193-4-coltonlewis@google.com>
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

On Wed, Nov 02, 2022 at 04:00:06PM +0000, Colton Lewis wrote:
> Randomize which pages are written vs read using the random number
> generator.
> 
> Change the variable wr_fract and associated function calls to
> write_percent that now operates as a percentage from 0 to 100 where X
> means each page has an X% chance of being written. Change the -f
> argument to -w to reflect the new variable semantics. Keep the same
> default of 100% writes.
> 
> Population always uses 100% writes to ensure all memory is actually
> populated and not just mapped to the zero page. The prevents expensive
> copy-on-write faults from occurring during the dirty memory iterations
> below, which would pollute the performance results.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>
