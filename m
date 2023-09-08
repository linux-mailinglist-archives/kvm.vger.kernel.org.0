Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566A6799129
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 22:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbjIHUqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 16:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjIHUqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 16:46:23 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4048E
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 13:46:18 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2bcb54226e7so29721431fa.1
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 13:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fortunewebnetworks-com.20230601.gappssmtp.com; s=20230601; t=1694205977; x=1694810777; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UR7nNKMPiwexNnKeYOaLsFDPVY7i/4+ar2d8M0cEnJ4=;
        b=vTua+2zuigp47F/eCIepbYBqLUC+YhlLP/acRmJjnwVdn6Lr9BnUQeA8k77hkPRRyt
         sdZ60Bi25sKSOXIcfLnvxIL67YZAA+oZqeLwhlxWDWdEPV+kqx35qk2fI85nt+PId4Gj
         MfCsZSK7jRCc9WQeXmehP5FzlN4m4zueOHIWlTuvVU5VQ1DWLfcVUi51Ygafx37ZKiro
         AnHwCj7LmXu0rja1jCxv+YhdXdamC+dRkWsqFqI0qcg2YnojQgirGwAP4JMYLWW3qXk6
         E9Wdfot4KmWoSudHkqQeZYWbeWPAQvcMf0f4AA/IxwDY+eMsl8J9Aouf6eIN+S/g0Klu
         PsLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694205977; x=1694810777;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UR7nNKMPiwexNnKeYOaLsFDPVY7i/4+ar2d8M0cEnJ4=;
        b=urZZ8QWmRMfkf1FC4NMh1Cd8lRHe5YgSGstIXBrh3SnCQauW3rHANx0ARzrJ+kbyXz
         tBVaSKoPaSiP4lA7mQP3+QxaCX6Toy7fHJpeKY7M/EdNxDYJBi54eeJoxom9EqhcubFI
         btRMAPofV7SbgQrm09dPxK7zbHCkjNc6Wyd3n79HmyrBt3T/Wac7ZdQBRtd+BVHhXc4T
         EBCMTg+uebXLx/rrmraIPXmfTWSQ3YhNM+oqt/fqRxrt/VlGDe94shwcBeQLA5w1wYfY
         o2kg3Umry0BXMQaQYkDFNB4U9c8146f1+Km3najRxiI7sKdFx6Bwk1dP76omf+q6Q7Xk
         YfDA==
X-Gm-Message-State: AOJu0YyJ01TbxbhsbKOSDAtZ1bWZUIxA++jkYdu4Q+kDBchUxtTrF2jt
        tzi37G3OvZGLGBnzLAtn6RFjOK1NDLl+mTJiKUuI6Q==
X-Google-Smtp-Source: AGHT+IE8MaAur/bCI0Y6KiQuaDlB1e1Xum9FjD4E0d5siQ5LzRKDe9J8c9VVi1KCUZEMiM7HSbOYIELxwPwMD7ZN1HU=
X-Received: by 2002:a2e:a266:0:b0:2b6:9f95:8118 with SMTP id
 k6-20020a2ea266000000b002b69f958118mr2542658ljm.7.1694205977270; Fri, 08 Sep
 2023 13:46:17 -0700 (PDT)
MIME-Version: 1.0
From:   Michael Jaden <michael@fortunewebnetworks.com>
Date:   Fri, 8 Sep 2023 15:45:51 -0500
Message-ID: <CANF7a-9eDC6d9Eahx7ZcumDYCxQcRUb9W0E=obf0VZVhaLQk-g@mail.gmail.com>
Subject: RE: AWS re:Invent Attendees Email list- 2023
To:     Michael Jaden <michael@fortunewebnetworks.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,FILL_THIS_FORM,FILL_THIS_FORM_LONG,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Would you be interested in acquiring AWS re:Invent Attendees Data List 2023?

List contains: Company Name, Contact Name, First Name, Middle Name,
Last Name, Title, Address, Street, City, Zip code, State, Country,
Telephone, Email address and more,

No of Contacts: - 40,777
Cost: $1,977

Kind Regards,
Michael Jaden
Marketing Coordinator
