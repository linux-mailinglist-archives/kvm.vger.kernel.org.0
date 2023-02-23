Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD076A1396
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 00:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjBWXNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 18:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjBWXNq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 18:13:46 -0500
Received: from mail-oa1-x44.google.com (mail-oa1-x44.google.com [IPv6:2001:4860:4864:20::44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD18D2E837
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 15:13:45 -0800 (PST)
Received: by mail-oa1-x44.google.com with SMTP id 586e51a60fabf-17264e9b575so8436811fac.9
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 15:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kKcu8NAkKq3XxsrTPCWIgzzlesxOM4/iDGN7Fi4T7OI=;
        b=jRqbTJ8v7u2lC6XRWR0X1nee2ABebst8VBrq+W5IZXoq8Ae0AIxRF9rjm7WxG+td5V
         8QvNrukRliYXTyMi9ugD9syw80C25EfBk9m89DpOlGpbP+rPIxMT8SltyO3HK7kNNACQ
         rJB0Qshr7r3J60XA/m7FY/1zYB6yBv+SSQVPkGi33frLaif/0bqhHh0BzSc5UtzzbEgH
         yswuICf7ChB8B2ljpJ1j6eQn2YANM/YCDBXm+kQLvWOrveTPYYZ5xeCfz77OskGUUdEc
         ikovKMBbjknD4v/+hTXIKyJV/m3gH9xnH6b8sKLjuw6hFAl9UZ7jRdh7m6/B7c9Y9yOE
         joAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kKcu8NAkKq3XxsrTPCWIgzzlesxOM4/iDGN7Fi4T7OI=;
        b=kIEFvIPfcf0MT57u4P5kVz3n+r/uEIsCFTms3yf5uKBef4iA083VbHt85PraD4BTrp
         Ov/mNyB7KvqB6wJ5gMQQr3s692ttZQbaJ9TjgwY0lzpBGS6iNDCuWvL0zdJF2d8t8AUX
         zfzl0yZzr58TkbB+AnU/dNUiVF5UytlubfpUod61vqBBvfldCeASeoFZ/dPdrcqUvkYC
         xYXVbCV4/+oO/peVCi9BC3DazF9sSFm2oNIHRRNI0K/MM3uhNSr7HUYWlMmhwREemHQi
         tGYh6rygH7yZyD1bvfHRuliKx5ypSPlYhbSDq6LUjoXNnoQ+HAJ9DJP6AFJd7B6UDo0+
         aUaA==
X-Gm-Message-State: AO0yUKXSS2yQTMJgtsYhz0w8beY/YtxJ2GTmhK5gtxwFce1bRDKL4bzf
        ejW9t+c6U1ebUVFOV42Mrfq3F+DNMsZ4RAsILOA=
X-Google-Smtp-Source: AK7set8kMl3VnOXQKPHpYzH+tEVQ5zPRPmws/jIRKk9b9Baa+sdS0KPL0gFTpetgQ7tO4ES8GKZFIuVbG91/zAJO7Wg=
X-Received: by 2002:a05:6870:c7a7:b0:16e:1dad:3ab5 with SMTP id
 dy39-20020a056870c7a700b0016e1dad3ab5mr477023oab.3.1677194024499; Thu, 23 Feb
 2023 15:13:44 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6850:d20c:b0:433:c42f:de9e with HTTP; Thu, 23 Feb 2023
 15:13:44 -0800 (PST)
Reply-To: enocvendors@gmail.com
From:   "Emirates National Oil Company (ENOC)" <koussistella435@gmail.com>
Date:   Thu, 23 Feb 2023 15:13:44 -0800
Message-ID: <CADtNC_cHB2OOv6nFpMOD=8_i6L9FRkgh6quhuwCC=d97dhbFTg@mail.gmail.com>
Subject: Emirates National Oil Company
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.5 required=5.0 tests=BAYES_60,DEAR_SOMETHING,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:44 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.7522]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [koussistella435[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [koussistella435[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  2.0 DEAR_SOMETHING BODY: Contains 'Dear (something)'
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Sir/Madam,

Greetings of the day,

We are inviting your esteemed company for vendor registration and
intending partners for Emirates National Oil Company (ENOC)
2023/2024 projects.

These projects are open for all companies around the world, if you
have intention to participate in the process,
please confirm your interest by contacting us through our official
email address  (inquiry@enocvendor-ea.com)

We appreciate your interest in this invitation, and look forward to
your early response.

MR. Nasir Khalid
Senior Project Manager
Emirates National Oil Company (ENOC)
