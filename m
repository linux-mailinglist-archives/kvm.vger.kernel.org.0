Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D3C5ECF0D
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 23:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbiI0VBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 17:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbiI0VBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 17:01:40 -0400
X-Greylist: delayed 8630 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 27 Sep 2022 14:01:38 PDT
Received: from server70.tadserver.com (server70.tadserver.com [194.59.214.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8912EA1D13
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 14:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=moderntarh.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:Reply-To:From:Date:Subject:To:Sender:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lgSJPHZygRr+RLXRbncZRNMSy/zf3X2kMy/EIvCfKEE=; b=B4L3rtKAJtln2OU4fLPCw6AVQd
        v+XGD8ssoJEBbiR/QXCe/fZXUvhlPBKyah0v+Qw0ZsbwuqMobh1vEqxkdkrHaWKMAf6CKKCuJlCMX
        6dPqBU8ZcF6JKvZsNQASixPVTJICB4E16Szl/NQ5ZwPrmHmsEQ+jmSaxxeqsKQlIHX6VZCpJmc2p1
        lOD4Iid7CRijRExeTbjuAJVVd0VJOyEmUq7JdNXTV2RbMHl8vooxNgISOPhmjt8OLS5e7pEU/HrBR
        +flkc0QbfN6CWcQyW9KTho/ltPaU84IGMjJajHUahCCbXuuHemt2JaaQESsHjVrF90NUvZBt6M/Mc
        ASx/d2ig==;
Received: from moderntarh by server70.tadserver.com with local (Exim 4.95)
        (envelope-from <esq.paulmartin@lawchambers.com>)
        id 1odFSj-008SIR-1L
        for kvm@vger.kernel.org;
        Tue, 27 Sep 2022 14:37:45 -0400
To:     kvm@vger.kernel.org
Subject: =?UTF-8?B?0J/RgNC40LLQtdGC0YHRgtCy0YPRjiDRgtC10LHRjywg0LzQvtC5INC00L4=?=  =?UTF-8?B?0YDQvtCz0L7QuSDQtNGA0YPQsyw=?=
X-PHP-Script: moderntarh.com/wp-content/fvk.php for 102.64.213.69
X-PHP-Originating-Script: 1012:fvk.php
Date:   Tue, 27 Sep 2022 22:07:44 +0330
From:   Paul Martin <esq.paulmartin@lawchambers.com>
Reply-To: esq.paulmartins@gmail.com
Message-ID: <87d2d0b0c4457937c7281b937cb2ed98@moderntarh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server70.tadserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [1012 983] / [47 12]
X-AntiAbuse: Sender Address Domain - lawchambers.com
X-Get-Message-Sender-Via: server70.tadserver.com: authenticated_id: moderntarh/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: server70.tadserver.com: moderntarh
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Spam-Status: No, score=2.3 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FORGED_REPLYTO,SPF_HELO_NONE,SPF_SOFTFAIL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Приветствую тебя, мой дорогой друг,

Я уже второй раз пытаюсь связаться с вами. Я надеюсь, что вы получите это сообщение в добром здравии.

Со стола: Барристер Пол Мартин, эсквайр. Калифорния, США. Я пишу, чтобы попросить вашей помощи, чтобы стать ближайшим родственником и конечным покупателем. Эти деньги на сумму более (8,5 миллионов долларов) принадлежат моему покойному клиенту, который умер несколько лет назад, и банк поручил мне представить бенефициара или деньги поступят в казну банка по мере
невостребованный фон.

Если вы заинтересованы в том, чтобы помочь мне, мы разделим 40% для меня, 40% для вас, 10% для детского дома и 10% для любых расходов на доход, которые возникнут во время перевода. В подтверждение этого сообщения, указывающего на вашу заинтересованность, Ответить на мою личную электронную почту ниже для получения более подробной информации с вашим:

(I) Ваше полное имя............ ,
(II) Ваша страна .................,
(III) Возраст ......................,


Надеюсь скоро прочитать от вас более подробную информацию, и я надеюсь, что это сообщение дойдет до вас в добром здравии ..

Искренне Ваш,
Барристер Пол Мартин, эсквайр
(Электронная почта: esq.paulmartins@gmail.com)

