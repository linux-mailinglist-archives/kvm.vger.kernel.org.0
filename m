Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F33734D7E
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 10:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjFSIXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 04:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjFSIXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 04:23:10 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663A8FA
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 01:23:09 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id 006d021491bc7-55b21c3f359so1953061eaf.0
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 01:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687162988; x=1689754988;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rJ/7Kbo9gs7zs3QTF5nFKkJrBjocKGAtdax9LA/wsFg=;
        b=RgtJLR+2FxtoGCVYnptEGdO7Cw3StWnJRBa3Z8OfFjytdH9wWfutBpN8ka2YIYHhLO
         Ubd1DagLH/8PGfo8xcmOWWreErSwu3o592+f4WSZw6VZdKsEf79tqR4v2XNEv+4uRAXF
         7dzRZP5PRr/DxHs95MhowDaUK+UAPt7+10kof3SSfYPkXuQO0O3zTd3rYNfvoVsQsNB7
         9ohkDKgKcyyS32zgaFo1u39on3boEFGASf0O07gSnQi7cKXMHSjqgKxr8224HXZFsCrz
         ox+Hz0jSXDVC8NWsDZOfjlpXl02Hnjufj2GPJ/25bPgttyy07MAOOz9kX90lxuuz1Ot+
         t7DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687162988; x=1689754988;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rJ/7Kbo9gs7zs3QTF5nFKkJrBjocKGAtdax9LA/wsFg=;
        b=IQonx+v4oRJAG6P9PGPJ9iAO2orRNux1sB24cRbHAO8AsTd5am9xb0IHerX+Z7qBBk
         hK8bhjHlNLpCOcikzGSeQEJgTxyKVRP+1FV8tp/NVHhXCvOQkJq0dqxUw+0iKyLyJ8Uv
         eCnCWfuQlhS7h36SIGUlMYDg2XE+Za2QGv8xM7P9TzO9ae7OxjSn+a+v6gWisBYbnWVC
         gdhAapVk3SiEtJ88wZyCiTuc/mN09VVAk8sTlKQgejfRi/nBsH89Ern5p8ihJWeLw11f
         X62gv60tFsNkZzFK+PxJ55sY4I02wWvYwFRYOObrF2NyP7evOeA9iq2cuYVFAU5vlhK8
         HxHg==
X-Gm-Message-State: AC+VfDwjbXy9ZrdZB27EJ3bm2XuIjFadNEJOVfHxKhlonJB9FsXZI+FA
        796ILsgV4dE1GNszN0k2XK8kpvd3L7qlVj7uOfY=
X-Google-Smtp-Source: ACHHUZ7xXWI1tUNtP/JB2dF1+YgJ9pCGhDZ2nbjCMGY6bBUrWZGi7lemw+OtzL1PNiza9ybvjNZEOwjbA7YROhNuljY=
X-Received: by 2002:a05:6808:179f:b0:39e:df4f:e68f with SMTP id
 bg31-20020a056808179f00b0039edf4fe68fmr1411558oib.6.1687162988421; Mon, 19
 Jun 2023 01:23:08 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a20:7a03:b0:11f:4412:fc6f with HTTP; Mon, 19 Jun 2023
 01:23:07 -0700 (PDT)
From:   loan offer <skyexpressccourier@gmail.com>
Date:   Sun, 18 Jun 2023 20:23:07 -1200
Message-ID: <CAPmwR52j7zm-Awe-ot5fGOpMsqBUBT3=-J55ZhyWw_ET0GurJw@mail.gmail.com>
Subject: Greetings From Saudi Arabia
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.6 required=5.0 tests=BAYES_50,DEAR_SOMETHING,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Sir,

Need funding for your project or your business ? We are looking for
foreign direct investment partners in any of the sectors stated below and we are
willing to provide financing for up to US$ ten Billion to corporate
bodies, companies, industries and entrepreneurs with profitable
business ideas and investment projects that can generate the required
ROI, so you can draw from this opportunity. We are currently providing
funds in any of the sectors stated below. Energy & Power,
construction, Agriculture, Acquisitions, Healthcare or Hospital, Real
Estate, Oil & Gas, IT, technology, transport, mining,marine
transportation and manufacturing, Education, hotels, etc. We are
willing to finance your projects. We have developed a new funding
method that does not take longer to receive funding from our
customers. If you are seriously pursuing Foreign Direct Investment or
Joint Venture for your projects in any of the sectors above or are you
seeking a Loan to expand your Business or seeking funds to finance
your business or project ? We are willing to fund your business and we
would like you to provide us with your comprehensive business plan for
our team of investment experts to review. Kindly contact me with below
email: yousefahmedalgosaibi@consultant.com

Regards
Mr. Yousef Ahmed
