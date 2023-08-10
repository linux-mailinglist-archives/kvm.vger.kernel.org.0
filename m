Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969D17774F7
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 11:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbjHJJzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 05:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbjHJJzH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 05:55:07 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F29E7C
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 02:55:07 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id a1e0cc1a2514c-79a31d66002so222729241.3
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 02:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691661306; x=1692266106;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iol3jaxrzuORdJBb2/hbufIyhmncgMYWqRL3cinA+2A=;
        b=YnyxsCjiJ9h+GjC+KqMEoEkhrW37/3hVIEqIHTNGsiU8SX+o4cL45bsb+aRiFTP05i
         uNSwsAryEkwdAtOoS51/Cwv+1YQdi4kGBcM3m21lky5VNJAp3LEOiGmleKFVWnW2Rd0I
         tdJDtzPTVxI9gY1oNtbocmgVI78wXNjcX/ejoHlVYOa2ajTmzUVV0q9MjqbSZZs47kul
         5QA64MftO/obMKcxLBwRAECSEJaiy9UAhtqW2vd35dZ5DTLSUiaaGTBfv2NcPLYwF/pp
         iM4IS4SGPi2rH0XYA9NZQtm9SCcVkbO3+LCLRh5WGC9X+g4ccOf0mxTryEk/PD8LvpAh
         tLug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691661306; x=1692266106;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Iol3jaxrzuORdJBb2/hbufIyhmncgMYWqRL3cinA+2A=;
        b=AQ26Km5blNaXGx+ZTz0zO5QxSLsI2YZ+mNVKJY7akAh0+XoNCIZ71M314Ak+tAEO7h
         lKhN9TFiolkMz3Zj8AEyW1DWcNHFhr+u3At0p22x9kSn3MJxbaNVvi9/iBYH7O3zKwYP
         5nzKUI07pvdGBhJxqP50lTnWqtgfd6XfuAf35f+RJaXkWw6q79DfGbSQOYcMtCrpywRZ
         SE/TKOSpX5uacrJK+LwtKI7uU4JfBb4DChrf7Tw9O0Q1PecCS+wIymEJDt95vO55RGNC
         a3qOxhbvqzzc0Rv3hpnvxMUgYgZgXB7zaAl0+Q7bMvccNOoAut8vR/U3+wzLgOQ694+U
         wK8A==
X-Gm-Message-State: AOJu0YxYvNnWfpC7oeVpOAUH7L3i3bh7R910yXE3naJRwiPDzGAqF3kK
        Rl7fRtGRIDcE5fTEqf6VbbczXwYMkppVtzZViXo=
X-Google-Smtp-Source: AGHT+IEOkrZpTDJhOwhw5GcwBGxDsrJHBd1be7cD76u6GP/nugtHpdBX2oha5eUsmLrQDTJsRLk7BB8dPUQ6YVrc4Qs=
X-Received: by 2002:a67:f692:0:b0:446:bf73:771a with SMTP id
 n18-20020a67f692000000b00446bf73771amr1286718vso.20.1691661306454; Thu, 10
 Aug 2023 02:55:06 -0700 (PDT)
MIME-Version: 1.0
Sender: profluckmanhendricks.sips@gmail.com
Received: by 2002:a59:b92a:0:b0:3e4:9686:b0f6 with HTTP; Thu, 10 Aug 2023
 02:55:05 -0700 (PDT)
From:   "Mrs. Angela Juanni Marcus" <juanniangela@gmail.com>
Date:   Thu, 10 Aug 2023 02:55:05 -0700
X-Google-Sender-Auth: W1g5sc8LTZ7r-dtXHJwlDz7pjgE
Message-ID: <CAABs9r7N3wKwEjwEPdgJ5x55gUNRD8pBymdxhxjKbAxy-ph0WA@mail.gmail.com>
Subject: RESPOND FOR MORE INFORMATION....
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, good good morning from here, my name is Mrs. Angela Juanni Marcus,
can i have a private discussion with you? it is very important to me,
please respond for more details.
