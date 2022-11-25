Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A39638A4A
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiKYMki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKYMkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:40:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C0E4F19F
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 04:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669379857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=73egeWiM/cXctA+ZU+cCWnnu/guZR1FZrG5q8HouGkg=;
        b=UupgC1UkVkr/lbnoHovjmW/mP85AbyPe60ZbXXABJOMzFbC4RdHNv9RGnSXXDwu462jExo
        0VMf2hdqtQVXQd8vuAeWXzC4OMsgjtgQFH8MlGcPix23Bah43vdA+Z8Awm12RlsmXmQ9ig
        3xWjE70jiF+rkKhoUhwMWVooEU6HOQo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-264-nVqtrza2M7OD5undl8kDyg-1; Fri, 25 Nov 2022 07:37:35 -0500
X-MC-Unique: nVqtrza2M7OD5undl8kDyg-1
Received: by mail-ej1-f69.google.com with SMTP id nc4-20020a1709071c0400b0078a5ceb571bso2226070ejc.4
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 04:37:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=73egeWiM/cXctA+ZU+cCWnnu/guZR1FZrG5q8HouGkg=;
        b=KUze0oJFvrWqIcgzHTGXgmFyy7ayHA1jvDHdBHlBexo21p4ZAOO+0/TP66i5JrEMEY
         bfwgKBFt1y+NUnEiAS1iRIPBWiXagMT3DIej+irWleL73JQ1TfFBV1Kw7Mg1HBmtNElw
         +dXINalgnMKA7tBxjsPUGiRLTpgcS3kqfUkzKrvXEiX4jthNCQ2tR9OXnI6NMCZ2zj96
         lZ09SM0gef8AwBJ8ezxNF6JAgPYjvAhr81QZlDjf5Du6wjRW20FIsyOpvhm2dB5u9smm
         tohTujpl+vJ5DNiq12QkngwNd47sPrbTSuzPcRt3pRQ3tVd1WImJZSXeILUeMNedMCFi
         Z0Yg==
X-Gm-Message-State: ANoB5pmz2hBFX7/XQjQZOaJQd36WlwBEUn1f8+EPJo3+GL/kSiUyuAEt
        UHYp6Y3kwxPgIN2mG+TD9G/d+alUUSQQ19D0N8Zvu6fLStYRKXifoXnUlT13OITvMhpIeH1Cf6B
        ASXmKKQxnp5jC/W3qOQA5xYs6MbbE
X-Received: by 2002:a17:906:52d3:b0:7bb:4d2c:2192 with SMTP id w19-20020a17090652d300b007bb4d2c2192mr6135252ejn.416.1669379854432;
        Fri, 25 Nov 2022 04:37:34 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6szBa0pJz739nimkoeOGze/dFb9wnbsj3UJ/z4LeboIeGHr9bpoTyxS3yUctpFH+e9ZBJQhRMTR3808H30jeE=
X-Received: by 2002:a17:906:52d3:b0:7bb:4d2c:2192 with SMTP id
 w19-20020a17090652d300b007bb4d2c2192mr6135235ejn.416.1669379854201; Fri, 25
 Nov 2022 04:37:34 -0800 (PST)
MIME-Version: 1.0
From:   Sandro Bonazzola <sbonazzo@redhat.com>
Date:   Fri, 25 Nov 2022 13:36:58 +0100
Message-ID: <CAPQRNTnV_Y+jrGA4+5j_WyGP3jaAC6zuBLLNHwYzwWM=xEr-DA@mail.gmail.com>
Subject: Broken link on Virtio page
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, just noticed that within http://www.linux-kvm.org/page/Virtio
page, the link for "kvm-guest-drivers-linux.git" pointing to
https://git.kernel.org/pub/scm/virt/kvm/kvm-guest-drivers-linux.git
leads to a page with "No repositories found".
I'm not sure where to report it but http://www.linux-kvm.org/page/Bugs
suggest writing here.
Thanks,

-- 
Sandro Bonazzola
MANAGER, SOFTWARE ENGINEERING - Red Hat In-Vehicle OS
Red Hat EMEA
sbonazzo@redhat.com

Red Hat respects your work life balance. Therefore there is no need to
answer this email out of your office hours.

