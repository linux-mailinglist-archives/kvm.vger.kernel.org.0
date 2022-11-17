Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8573662E61B
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 21:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbiKQUqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 15:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbiKQUqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 15:46:14 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C1E6B202;
        Thu, 17 Nov 2022 12:46:13 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id v17so4311527edc.8;
        Thu, 17 Nov 2022 12:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KgP3S5wtbBYj8SdinzbCrfNvgAs3PAFvpROmucDmbrA=;
        b=k26wURFJjpAGes5Qg4IUZqpMYdFUDn7hDKafR8BbKTEHRDYmdDQzgFxd9AHBDcnzKk
         O62ZCtW5/2bfj6z0aYF70pxnjN2sfoiLB2tz4VS3s1G7DuSdMO71YcH6f4w3H64x00aA
         OyMnYpEB4LQMTKdYfjl1Jr21JiyyJA0hMKj7Be+QnceuUhqVnWrh2X6ZZnrpXfPYyAhO
         rhj2b8YYDqNsjMRP1VNSnf4Vr4vdLsU6FbpwyuxNPgG9RPEUDlizbLIgGIYUE6ZPTNTR
         6q0XEiCr0YmSd92Qbl8ncbAnY+GXkbFMtcm38XgoZnO9sCV7lXLno6zcFGtan7tJPjQ9
         NL0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KgP3S5wtbBYj8SdinzbCrfNvgAs3PAFvpROmucDmbrA=;
        b=rdnZ7oBCVRuj4M0YAamoWXTt7dVIIPoCHacxTA6AG97k/ue4oWLCS4pGuc9LM7ryCb
         0gw4VPXfSd/Rq0XJodLX7rCuOAHFgA1LocRmXGAlW7HIawrRInmAykR5L3yGSvEzm7oD
         wnVqRcObyx64BQRRlJ8s6+V1Q6bJzQVufBfNhecxC8AoFo2/YhJJvLw3xxinseNYFIU6
         iIjJCSRnhwoJtysq7xFBJxhRakObS0412img3hU1Kwq20BCCD2ctngruqvFxabwwci0N
         eMWEFNFtsPI0TYJJLEpp6qYaQgHHGrjY3tBYuoUYfekpEUA3r2mE8a324Ny37Fe5il9X
         uzcQ==
X-Gm-Message-State: ANoB5pl7rJRkXUg6QwhI3g04ZXLLgB43AjUhBrasXP5GVDusqN41Bcj1
        O21Kp2wDvI5efSc3Wl4tk0aryXj0bQ==
X-Google-Smtp-Source: AA0mqf46R7FNldX4UnKK+YEeYLbviqKumheQQ+kiPkF61el2DTpnVmMl/lEZtcTMLbzmNTYG5B/bEQ==
X-Received: by 2002:a05:6402:13d1:b0:469:4a1:96af with SMTP id a17-20020a05640213d100b0046904a196afmr799937edx.328.1668717971613;
        Thu, 17 Nov 2022 12:46:11 -0800 (PST)
Received: from p183 ([46.53.253.26])
        by smtp.gmail.com with ESMTPSA id v27-20020a17090606db00b0078175601630sm809209ejb.79.2022.11.17.12.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 12:46:11 -0800 (PST)
Date:   Thu, 17 Nov 2022 23:46:09 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jpoimboe@kernel.org,
        pbonzini@redhat.com, x86@kernel.org
Subject: VMX HOST_RIP target alignment
Message-ID: <Y3adkSe/J70PqUyt@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

One of the side effects of fixing retbleed for VMX was demoting
HOST_RIP target from honorable function to a lowly label:

	-SYM_FUNC_START(vmx_vmexit)
	+SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)

ffffffff81243c49:       0f 01 c2                vmlaunch
ffffffff81243c4c:       e9 a7 00 00 00          jmp    ffffffff81243cf8 <vmx_vmexit+0xa7>

ffffffff81243c51 <vmx_vmexit>:
ffffffff81243c51:       50                      push   rax

Now I've never measured VM exit latency but is it important to align it
at 16 bytes like Intel recommends for functions?

	vmalexey
