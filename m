Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68033EC2F6
	for <lists+kvm@lfdr.de>; Sat, 14 Aug 2021 15:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbhHNNrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Aug 2021 09:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbhHNNrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Aug 2021 09:47:21 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB23C061764
        for <kvm@vger.kernel.org>; Sat, 14 Aug 2021 06:46:52 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id qk33so23437050ejc.12
        for <kvm@vger.kernel.org>; Sat, 14 Aug 2021 06:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=4AZ1AJeMaRX8UFjXxzRMIl8YBshfCF9BmUv4FOR1jf0=;
        b=aT9gNi2lAqX5Tpg1RxQIkrstMgcjDJYx1XTiLcU9WYe1s3RE3xKShpK4xym5vmDKfv
         vaxNSHY8cDHZYTNaUle8cwbTPpf1lZ0DxAu3Rez/AlUc+LkAIEMhyMtwelGR+9VjCMTB
         ybtpWCfjPIZye8aLRVhpGZpI9dYtwn6eAVdX4nzhyQSZXvsnf++iNyfvg6lR5eHC1xm9
         AiCruS5GY6MLc6rOQgPk9NPnP5R2wwH/x8Pqu/EyWbbv+S2cbltRUddQaMKKJXsk/Bbu
         BZ+GjMyJUd9GKdx5Qi6IupLdI1A0hJae0KUf7Ylyb1dDNoT4R8T9cH9qm3pST8uxhmYi
         kMVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=4AZ1AJeMaRX8UFjXxzRMIl8YBshfCF9BmUv4FOR1jf0=;
        b=tdwlwsqNOLn37Bbn0t6kzs/tVIzh02MuediI+YlUKpX9GnJPCaiTx1G8VQu5/xrMBP
         S4X8iT5mKXzud3qQdWeegrb+ZKRPzkerYFOjNpnNtrG5aaMt4IZO4wkKBeXiDDdxaqOf
         moCNEoXDmB5xcIr70h2lo865s3zaSoLDwDd4A08CmjQNWQxe+QXmPQyN3XcdOQ/ztH3v
         6Ts7dJI8r47Ba2PvOl2EpLrZWAe/Xc42cNWyYbFOdN6RkILlOu0vozibG5ScxLSL6og5
         DI0jvpZQuArvXmUQP3yp9pIRoI79snetGkz6TfP+h4dH0oyObLVDJgFo+k0hxb/Fu5vc
         V0rw==
X-Gm-Message-State: AOAM530QoglQf617VyRpj9UQ8Z23a7Rf0VGzN9CdOjsg4xdbyrr4OCKX
        0+o+dF79PFmQRpK0I0IZAu/iZI2WxmFGzPLBMW8=
X-Google-Smtp-Source: ABdhPJyX13NhmwR+X5DoIQ2cv6suGHeI7AbmHOh6AyIVfH8Me6DwY2XzpcG+hIlDSQ/KRm/BPvDexrOCwLsqNGGmrXc=
X-Received: by 2002:a17:906:1789:: with SMTP id t9mr7587853eje.61.1628948811241;
 Sat, 14 Aug 2021 06:46:51 -0700 (PDT)
MIME-Version: 1.0
Reply-To: dibsankaraa@gmail.com
Sender: mrsnabila342@gmail.com
Received: by 2002:a17:906:304e:0:0:0:0 with HTTP; Sat, 14 Aug 2021 06:46:50
 -0700 (PDT)
From:   Mohammed Sankara <dibsankarra@gmail.com>
Date:   Sat, 14 Aug 2021 15:46:50 +0200
X-Google-Sender-Auth: CkcVW_wDNsyixj7tHrFue1qrUtc
Message-ID: <CAPjY_YBQaP1oSdQ10T5kMvy_HwyeeDgr=KbicPxiJsUTrfA1kQ@mail.gmail.com>
Subject: Please Reply Urgent
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Good Day,

I am Sankara Mohammed, account Manager with an investment bank here in
Burkina Faso. There is a draft account opened in my firm by a
long-time client of our bank.I have the opportunity of transferring
the left over fund (18.5 Million UsDollars )Eighteen Million Five
Hundred Thousand United States of American Dollars.

I want to invest this funds and introduce you to our bank for this
deal and this will be executed under a legitimate arrangement that
will protect us from any breach of the law.We will share the fund 40%
for you,50% for me while 10% is for establishing of foundation for the
poor children in your country.If you are really interested in my
proposal further details of the fund transfer will be forwarded to
you.

Yours Sincerely,
Sankara Mohammed.
