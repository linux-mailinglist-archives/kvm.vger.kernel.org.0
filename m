Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8BE6E6675
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 15:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbjDRN6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 09:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbjDRN6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 09:58:38 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4776D12CB9
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 06:58:36 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-2f4214b430aso1563256f8f.0
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 06:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681826315; x=1684418315;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vGySRZrs/b8njlSGrjtzjuPbx1JL14da6i8ba99Is3E=;
        b=uk+TxpZt6Ud9SwLze7/gzjXKw05Yu1KtKb35B0tsS7PBU94thWt40bsBQnk2eF3LsF
         VGSF2UHy7yiyV5v6l/Gxgwj0jlGWNW9Te+lqm4FvHAnXUpgRaF2V8+DTK1OjIAL056cF
         N4O8xbZEp5M498yKXJH7206ctyhRYvPnxffgyqwrjQTmo8+IYkw+QXK5e5H19mmPYd5H
         IBOO4vmjkGlDCbsUv4ZTgdQLOftAPmdBfGF9lttDBsoJkk/Iczz+ZZDoYZsqu9/vGqBJ
         hvdgbi+wMT3v/louhp5fKk6IZQWPLw42nGZlTIsgV5WzDz6K8C3dCJoaIcDXfMS4+kUy
         oK/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826315; x=1684418315;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vGySRZrs/b8njlSGrjtzjuPbx1JL14da6i8ba99Is3E=;
        b=YaBNTIy6fUKEWT8mkZ+uB/kUu/+BSOei0FMhDSqPdcH0RCVZPIOvnbyzgONpDk+ndh
         L/ZJxg9CKD8XFR3xWc/+x0aTdtr+gYo7xCOYMX4HxHm9Ytoe0Qd9hqQT79CRCyWXKC1j
         UcICKyrDL3P4GI7aozyEPwIjs0q3zm82961YxWdvcfiEUmI32iwHKjWOylF2LkO7EKYh
         X5xANggVzJUxCAX4eWjkLjzuiH5OnjiLhytQUGUhQ3WLb0IWRK7fXYJ3eRpHkIgiGKMQ
         ocYa3AfbYOsKGBWfN5Ecc0GRXAsOjCh62k9f+lkXrp5XexoxWx+SehBOgxhecCSeD92R
         7ttA==
X-Gm-Message-State: AAQBX9dVP/bxTmM5L1OBDV/gA/+oFZM9hmqX/MCcZIKqHL/thHAJJ1Im
        7tL+Xp6N2c+Gk9/HK1pDREzpEQ==
X-Google-Smtp-Source: AKy350azYH1QyIZJteWYhrBdTdgAMIOcRSwIxrUCxuU8o70MwNtV3fnTEbrIsFDkwL4jPZWFqPVqlQ==
X-Received: by 2002:a5d:6a06:0:b0:2f0:2dfe:e903 with SMTP id m6-20020a5d6a06000000b002f02dfee903mr2236438wru.69.1681826314647;
        Tue, 18 Apr 2023 06:58:34 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id b7-20020adfde07000000b002f3fcb1869csm13179900wrm.64.2023.04.18.06.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 06:58:34 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id C9FA01FFB7;
        Tue, 18 Apr 2023 14:58:33 +0100 (BST)
References: <calendar-8e6a5123-9421-4146-9451-985bdc6a55b9@google.com>
 <87r0sn8pul.fsf@secure.mitica>
User-agent: mu4e 1.11.2; emacs 29.0.90
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     quintela@redhat.com
Cc:     afaerber@suse.de, juan.quintela@gmail.com, ale@rev.ng, anjo@rev.ng,
        bazulay@redhat.com, bbauman@redhat.com,
        chao.p.peng@linux.intel.com, cjia@nvidia.com, cw@f00f.org,
        david.edmondson@oracle.com, Eric Northup <digitaleric@google.com>,
        dustin.kirkland@canonical.com, eblake@redhat.com,
        edgar.iglesias@gmail.com, elena.ufimtseva@oracle.com,
        eric.auger@redhat.com, f4bug@amsat.org,
        Felipe Franciosi <felipe.franciosi@nutanix.com>,
        "iggy@theiggy.com" <iggy@kws1.com>, Warner Losh <wlosh@bsdimp.com>,
        jan.kiszka@web.de, jgg@nvidia.com, jidong.xiao@gmail.com,
        jjherne@linux.vnet.ibm.com, joao.m.martins@oracle.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org,
        mburton@qti.qualcomm.com, mdean@redhat.com,
        mimu@linux.vnet.ibm.com, peter.maydell@linaro.org,
        qemu-devel@nongnu.org, richard.henderson@linaro.org,
        shameerali.kolothum.thodi@huawei.com, stefanha@gmail.com,
        wei.w.wang@intel.com, z.huo@139.com, zwu.kernel@gmail.com
Subject: Re: QEMU developers fortnightly conference call for agenda for
 2023-04-18
Date:   Tue, 18 Apr 2023 14:57:53 +0100
In-reply-to: <87r0sn8pul.fsf@secure.mitica>
Message-ID: <87leipe1h2.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Juan Quintela <quintela@redhat.com> writes:

> Hi
>
> Please, send any topic that you are interested in covering.
>
<snip>
>
>  Call details:

Please find the recording at:

  https://fileserver.linaro.org/s/nJTSCLyQBfo6GLJ

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
