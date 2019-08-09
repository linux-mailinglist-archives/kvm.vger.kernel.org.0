Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A5C87A7C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 14:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406704AbfHIMvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 08:51:35 -0400
Received: from mail-vs1-f47.google.com ([209.85.217.47]:41321 "EHLO
        mail-vs1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406273AbfHIMvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 08:51:35 -0400
Received: by mail-vs1-f47.google.com with SMTP id 2so65286328vso.8
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2019 05:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=esi.dz; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=5UBzzkBhfhCmXbym9qpOEVHCEWwrUg0+zEd3g0rExwM=;
        b=HSwUH0BTUo34YZfxX4iXwUvacNioGanXLtPas8yDr4LGQr3t1SSvQHR2D0Nrs3Mj1o
         RSxBjDl1SwigjKaFFlfsw1m2aPtyAgBxHcNJqC2UudDLz8gFamVWEVvcfuakHN2gzSIJ
         zRqehYtBYQiZdzAnG09qDnl+XuNeRse2VOr5GqQEjmz0iSMB8zJ4x09VhfI3qrmWynLv
         cK5fy9brUIQ0X/B7hVX5iEVkuNuA1ANo64+4sr5fStPKhPOKx36ruMnk/RERkTlsO/0R
         deL6z4zE/+IJcZR9nEBmLKoi4oWt2JSVLzx2kruqEljQdwe/RUGMH4jQa9DlBLlRR7A2
         i0AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=5UBzzkBhfhCmXbym9qpOEVHCEWwrUg0+zEd3g0rExwM=;
        b=jj9uygXJ8YZGwmun11jLm40Cswa/UHaXySbZLhdqWhcVaml+6g9s7fuq0EjN9oqIfc
         fZuLj//dsNAYG5YCRa+ulxWWAFp0NbdtQNZ+YQv8sB8wYE3F9jApzldaw4QCcDwXafy+
         RWEG5qIczBLS33cmccYqVQyHopnSrOkHr4fK6Ubx+2s5ygdNGdjjrDXme4HaD6+/DgQK
         fhZ90HybuWwF9tBeIzP8uwl+2VaCDD4/tSe5xUtrtjB25pZCwZaGLINple1/0xn6iHdF
         RJFTzz0WSL44WNDOZfVGdAYlkpQHriIfvRY1U4oTtVfe3ZPxSlNJ9ki7EWoInUJwHMmA
         vIRA==
X-Gm-Message-State: APjAAAVuqIcCtD15cFAF5hkF8aD4m1jJG5zFpoUmHpxKyhQZM8z1E6SK
        k/3kY0JTh4gQVV7GinqNfG3MePjMdKCYxPgytzqL64CJtCE=
X-Google-Smtp-Source: APXvYqx0VqWdq7sT5rxWojyy69ujkyd2K0GuieTjlUgY2WijPwFjUlJCDlshVWKULFq7dTfLRh5WlSQW7rwjL422XWg=
X-Received: by 2002:a67:e419:: with SMTP id d25mr12210434vsf.196.1565355094522;
 Fri, 09 Aug 2019 05:51:34 -0700 (PDT)
MIME-Version: 1.0
From:   HEBBAL Yacine <y_hebbal@esi.dz>
Date:   Fri, 9 Aug 2019 14:51:23 +0200
Message-ID: <CACEoar7tDRnNirvgfqEWniG4x8FpunEwnZaO0DzNivepqMOaxQ@mail.gmail.com>
Subject: [Questions] Building kvm-kmod on 4.0+ or 5.0+ kernels
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,
I would like to prototype some research systems using kvm-kmod on a
recent kernel (4.0+ and 5.0+).
However, available repositories seem to be out dated and do not
support recent kernels.
Does anyone have a standalone code of kvm modules that works on recent
Linux distributions ?

Yacine
