Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB134590F9C
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 12:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237954AbiHLKlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 06:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiHLKlu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 06:41:50 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E099B6318
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 03:41:49 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 24so484254pgr.7
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 03:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=447DttLGWlnXVhl3+i4qWwJxEj6tFprhGwRHCuyrWEY=;
        b=bjNpp12yplcN1Ln4lxt6Lwpgmc24Jcm6VfHqAHwIcrhX7ILz7XeuJi75zcWrdt9oKX
         x23IQZrFoip8FSUT99yyTJCL71Bz7Ot8YL7GvophbL2X59jC5KLhcDxlxHCSzst2ad42
         941VQJa31FjjMFESrFUiMMa17jVjNO6qSYexU8cj4onOpnd3TPn5Zd7pEPl4GKPP33+E
         XnbGV/rtHBK58HFFEfwIb8ls7MYSNRItJh9ZfLzzVLH0S9d+U/qzgjy1DVDU+q3+5JUU
         +TAMaVzIoZhLja84zql8nWP/cjgqRV0hdjIkBw7EmJioruOMENtoNRrhavk9Wuz+QuXw
         +HLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=447DttLGWlnXVhl3+i4qWwJxEj6tFprhGwRHCuyrWEY=;
        b=v9VI7D0Oc58aF0mgFhvml6i9YD9ArAZxOAjd/mcDPNSjTUIbQdzeUkltU8E7NdvGaO
         j+Pm5S2kWQIBBkL3BvAaShKLgKb7hcJ1nPKyKwJ+KjaRvHQ8yc6BCV+oxAXjHmqQ4905
         QyoXwJDMTf0xBBh4DS81Km+DzpvUwS+98gpuWy8bfPdzkV+4IQBflWpdU6rzlOFH4HGY
         qaBS3ZPivljbSPb80Be/R3Ap6j0fUqfl24BdxlRGE415SugHwXJJv4eUEd7xflItDUWr
         g2aMv3KPjPD/Bf+0iCC0y/JZaMEYxW5rs1pttVNVvnmPivrfSgPrg4IZa4GwiDjvSZJE
         k0pQ==
X-Gm-Message-State: ACgBeo3LeeLT+Xnx6N6obQMavqLq4Dwp/QAE2dKkAvorgXfwOZtUekO7
        zcnmkDol87YVfEdcgMGB2+l/mhHvayI71MU5wj8=
X-Google-Smtp-Source: AA6agR5VfAs57M2Qyb/DaWQEopnpArP6AJOXdaUsT7gDzCcCVPTuICif3zrlJexjN0bzFtMqgfEH1dPpFoj+SWOF2FU=
X-Received: by 2002:a63:1854:0:b0:41d:e04b:44fc with SMTP id
 20-20020a631854000000b0041de04b44fcmr2613302pgy.237.1660300909376; Fri, 12
 Aug 2022 03:41:49 -0700 (PDT)
MIME-Version: 1.0
Sender: bazarkowanigeria@gmail.com
Received: by 2002:a17:90a:9f91:0:0:0:0 with HTTP; Fri, 12 Aug 2022 03:41:48
 -0700 (PDT)
From:   "Mrs. Margaret Christopher" <mrsmargaretchristopher01@gmail.com>
Date:   Fri, 12 Aug 2022 03:41:48 -0700
X-Google-Sender-Auth: NkFPpjvAzATBc0FSSvfrD19SFA0
Message-ID: <CAPgaJa37H1J11fSn1a6c05iFMuUz_jnYFkYfy=MuhdoyjqN1_g@mail.gmail.com>
Subject: Humanitarian Project For Less Privileged.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
Hello Dear

  Am a dying woman here in the hospital, i was diagnose as a
Coronavirus patient over 2 months ago. I am A business woman who is
dealing with Gold Exportation, I Am 59 year old from USA California i
have a charitable and unfufilling  project that am about to handover
to you, if you are interested to know more about this project please reply me.

 Hope to hear from you

Best Regard

Mrs. Margaret
