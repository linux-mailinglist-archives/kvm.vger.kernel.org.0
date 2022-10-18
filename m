Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B71E602E3C
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 16:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbiJROVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 10:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbiJROUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 10:20:14 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9159A9C3
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:20:07 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id l1-20020a17090a72c100b0020a6949a66aso14147725pjk.1
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=447DttLGWlnXVhl3+i4qWwJxEj6tFprhGwRHCuyrWEY=;
        b=QLrDwyQ9UQMJIOxxP+6FFu6ICWq2Ak7/+8SuKMa/aYEdWnofqWQ9zlDa00gret2pRS
         4OyldYnEgIqyOKyKcLToFcxXPIpYasdbUeo/sKMZp7A+OjjjeqsrgC3eNqwBgelDEVa7
         R0VYwf00xUco5gdAO/hu/3xpxYSznUBipDBTBMG51xzszveVx4WMApWX2FQG8gm5iYGY
         wWlykNM+H7xoLxqrSEakRbPVAh+H81VdENjp0TAujqmeBjyI+Z7MxT2quGdtUh5lD9Th
         VF4FcSkdV05dM/75+YxN+wQqaK8dJ4SorzfW7hB0dzqFhsQx15332+fUQi8sRLiyYV5k
         7SEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=447DttLGWlnXVhl3+i4qWwJxEj6tFprhGwRHCuyrWEY=;
        b=cSEMOY4hOda+Jr8zPy6lEARRwFMupUe8ANJVBGrfEPygJcjyQ2ytuQixhplvCtFJtW
         9biqh4zC+HjlqhrhpRTJ1R2gyZOsEothwv01f0xvmuz29Lk+p/YzyQBdsI200DW9Ks5h
         0FFa3M4wZ2K+9Khql03Ymp0rBdblXCQ8+aRTmjLk3tmQDcJyON6WAvnuNoojihN47o6d
         SuIh5D2bDcpmLv83oi63Kb0H60vPrnHLYepDriwCqU/Qo/Ie7FCld45lW0EP7Kv5iKO7
         jJ2svcL0I7TboXUiOLCuEO+argAy87FFoO1gFesQjKBeALr46v9d1L5P8EGkJseTc9wf
         f5Sw==
X-Gm-Message-State: ACrzQf29nAX8PUY7XfnY4C+BohZ6qJNhYgdBZUV2jxUeDrYDn+ErOizU
        bKNpaNkT7BoNTBZrVIyhiIViESuxPr09ZB6YsFw=
X-Google-Smtp-Source: AMsMyM4s/z8Pm1yIdzRjNqryYEYPMz65UYe5rBRU2I6erPA/yMi/YUwNGbK+j2Mrdai2oRHPz+bdr2FkMJ15o6AHR/I=
X-Received: by 2002:a17:902:f552:b0:17f:92d7:98f5 with SMTP id
 h18-20020a170902f55200b0017f92d798f5mr3153485plf.143.1666102806312; Tue, 18
 Oct 2022 07:20:06 -0700 (PDT)
MIME-Version: 1.0
Sender: my6556286@gmail.com
Received: by 2002:a05:7022:6091:b0:46:1f07:f00 with HTTP; Tue, 18 Oct 2022
 07:20:05 -0700 (PDT)
From:   "Mrs. Margaret Christopher" <mrsmargaretchristopher001@gmail.com>
Date:   Tue, 18 Oct 2022 07:20:05 -0700
X-Google-Sender-Auth: fxc0f-a_MmmVwf-PHvouAlEO1wc
Message-ID: <CAF9PdM3unwzi_K6mtNJJvHXn6n6osBo+=vhKe44N--qgbk1BFw@mail.gmail.com>
Subject: Humanitarian Project For Less Privileged.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS autolearn=ham autolearn_force=no version=3.4.6
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
