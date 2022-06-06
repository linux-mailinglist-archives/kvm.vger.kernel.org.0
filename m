Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE82A53F298
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 01:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbiFFXer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 19:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235258AbiFFXen (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 19:34:43 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FED9ABE53
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 16:34:42 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id b81so6917741vkf.1
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 16:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=Mx/5+GRlhRMbPAD8oj6vg2q4LfocibVUPw3pWVZvg0c=;
        b=I4oBFTex/2U0VNe3EnNd+6rL0VcZGmqhZ5Qz8dCyWrXxOI1QSvTOuQRCdX6yjpnK3T
         X58CKNndq4cpKN7+b50mWxoEU7aC/FuPXN6Oh/0g2rlwcxge2LRZbDvZ4j41oHGpUmol
         EQeqVqIa/3psqiZNQFQe8CCQ3HzYqTq1b9vy56CHkV0F4WzbUxsK8LU139lFiJFoyWWN
         8mTsgl1Wr6ftUytH9tasdZ8BJAv++DsaPNBOFcB0OCGOfpcBliKPg8lpYgKogw3SqbQ4
         Ex8S5ZfhCfpN87edQwKthqRxZeMRuZnvdTvgKvUuvR2yq6D/ZLozFIQOTlzpRHP7UHDi
         pVFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=Mx/5+GRlhRMbPAD8oj6vg2q4LfocibVUPw3pWVZvg0c=;
        b=Rdy2GBp/QTnUBPBiilMNUPzMpT8xcBtcHTF7LblVMrkpRjALyBYZuLlbCKWlRuYHlL
         zvPb/2siN7ely8iueJKvw/F856EDLWQfEgMQjCQ90GvjrKWXntJrxCrh0xYlgHNYBJFD
         pwLfkj5O8/fiGK/4WDGAzj2Jb0jtF9yE2QZb0nFYd3WMrcSJ0QwQaFmkAVwcd9f1h+TF
         ADtfMrGdq4ZcDUQNxS2DTThqsiR28WGxLK7HUVDQBfYr9jpf1rs7FatMRuLWjm0s1PLu
         nIo3p1AKValbPhFRV29oMfd+3LDKCQJWNoaGhHJ/OqMsnLomEyH85yCVtZR5vdeVUrKF
         gKCg==
X-Gm-Message-State: AOAM5320p0hCm2LPL3GxcIyPViCMJo2hdZmavPBNY/Y+p492Q7qmBx8l
        aXR7cYjf0JFOyE2arTMcYatWv4xIl1/1Z96vLSE=
X-Google-Smtp-Source: ABdhPJzsk3yFTAgKFNostRVxmtZz9Q/aeakfCD4G8rxZVazn4laleL7gdc5TeR8k+N8TE8FkxXBn6oWNyYXX2vaZPjY=
X-Received: by 2002:a05:6122:882:b0:357:a29d:9209 with SMTP id
 2-20020a056122088200b00357a29d9209mr10609009vkf.23.1654558481433; Mon, 06 Jun
 2022 16:34:41 -0700 (PDT)
MIME-Version: 1.0
Sender: rachaelmaikalu014@gmail.com
Received: by 2002:a05:612c:a8f:b0:2bd:d667:f727 with HTTP; Mon, 6 Jun 2022
 16:34:41 -0700 (PDT)
From:   "Mrs. Rachael Bednar" <rachaelbednar.55@gmail.com>
Date:   Mon, 6 Jun 2022 16:34:41 -0700
X-Google-Sender-Auth: -cuV9RCBQOCxnEzkxnM7WS2cmvI
Message-ID: <CAPUrDLo0AjnU=VTWZ+M4fOW4b2q3WoPhF91AK_t_OP4ZE9tZWg@mail.gmail.com>
Subject: PLEASE CONFIRM MY PREVIOUS MAIL TO INDICATE YOUR INTEREST.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Greetings beloved how are you doing today? My name is Mrs. Rachael
Bednar. Please i want confirm if you received my previous mail  to you
concerning Humanitarian Gesture Project Fame that i need you to assist
me and execute. Please get back to me if interested for more details.
