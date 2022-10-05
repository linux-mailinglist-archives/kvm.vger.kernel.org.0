Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA3C5F5CA9
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 00:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiJEWZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 18:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiJEWZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 18:25:26 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C3562924
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 15:25:23 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n7so47130plp.1
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 15:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5DzIw0o3sgFtBL3cbelSBL/2szHn6TlrGdfHUQFQwhk=;
        b=CTtIfjHDWkJRkinPq0yBkvrhCzU5kZ321AGFluQ6bdI/1qOJ7F43B4RNaMusenqwTF
         OnBYcopYgLWGcRSAREznoEn+GhSq3PzcJWqy4kwD6hyfHyf1onjeLV+aqI0P7TwYgZ6/
         ufhKLyMT7m3nDmYGqZqUaeP5rO8oJkAeKjMt4d9dMMaqFlN05r3MTu5Q1lK+KFXh6lSG
         VcI0J+fZkF0ANZFSdUiNb592ZFKL7p54GQ5snD3la2AxR+6TOLAx+C+NbV0R4gesmE+W
         Vu4Z1hHQVrnUtbvbOLuUP3cmmAckqjUMS+0eP6ujrdKyIOkctY5GGvAtYvtFWpn552Rx
         av7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5DzIw0o3sgFtBL3cbelSBL/2szHn6TlrGdfHUQFQwhk=;
        b=KRTT7TZ6tnmd3EGyEisD9hxzURsoTmPK/kl/7VTe6bX21AtiRFGBvQW0+A4ffRMNkB
         CPvmyeXvQ3xjYr97hbyTfFaC5YD9h43/l2aUsKBZINFU6MEmduO/Wzg77HVNXhkKi7x6
         cOKfyavWsdwQ9gpvNu7vXU8P4UbrsVIDZUaHwxVp5T+6VIiBE7JH6GGHdfBcejUBoNyx
         L6W773AmDSZyz3YW+hq36mIbcvQcRAmxk0E0UFqLHicSfHwbmYOZvZjIPDiSk/ZpDe3i
         ZNMGTCRIRP2RH/DhXWCjTV1am7/v45EuEXOQKYRHcX6f+QvOiBGPOc3nuG74e4IXEj00
         O1jg==
X-Gm-Message-State: ACrzQf3nB22uxWCj/XQdyX/YNkiYFGoYHomOFImsn+/xORGq6Z33iuCy
        seLoiPPfpuu1tZw2SFKD6Ir1oZXDIjPo6g==
X-Google-Smtp-Source: AMsMyM7DBuQaON9Ul9MEUXTRVAWYbDoxIsNf8dtghE62iBcyKroYgfSLme7dkVVnpZUX03zCMBEzow==
X-Received: by 2002:a17:902:6542:b0:172:95d8:a777 with SMTP id d2-20020a170902654200b0017295d8a777mr1446952pln.61.1665008723276;
        Wed, 05 Oct 2022 15:25:23 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n4-20020a170903110400b001753654d9c5sm11046089plh.95.2022.10.05.15.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 15:25:22 -0700 (PDT)
Date:   Wed, 5 Oct 2022 22:25:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 07/13] x86/pmu: Pop up FW prefix to
 avoid out-of-context propagation
Message-ID: <Yz4ETu25lFxEb79/@google.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-8-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819110939.78013-8-likexu@tencent.com>
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

On Fri, Aug 19, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> The inappropriate prefix may be propagated to later test cases if any.

Nit, please make changelogs standalone, i.e. don't depend on the shortlog for
context.

> Signed-off-by: Like Xu <likexu@tencent.com>

Reviewed-by: Sean Christopherson <seanjc@google.com>
