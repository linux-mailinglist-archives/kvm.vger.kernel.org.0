Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1426BEF0B2
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 23:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbfKDWmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 17:42:49 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:40868 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729701AbfKDWms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 17:42:48 -0500
Received: by mail-io1-f67.google.com with SMTP id p6so20391654iod.7
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 14:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=egt0s8stOvV2va8n8izky9pyMGcKEaWkGAOFwUvDaLM=;
        b=SeZ51UJ7KgL6BKgDObXTbqCHzi7n8j9Qih3p7XmrI+UFYhL54twoUKBEsnEMz8MVJe
         azxHCyBQxq6UxpfSmd/WfW090kfWZrMoUjiPvqLNXcspOZoUPaUIvklzM7t/hXIVFaHM
         g1RxsrBDUA9PAnTULEzt5CTD+rY0O9qqV8OmhgQcrURhRvy3naU8kKUd726PBCNLZlSr
         74Bqo2DVU7yRJqGw++0pJN8QjV1RXStcj+MyeBYD+tkeyRNSXv/xZs9bcmdArk7337yq
         Yd1cF3AORydwdUv1XeUEh3EzyzNFgycwFIR2dow6+K1dR0AjRD0pDAoIfsxIELBHa8Wk
         ggtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=egt0s8stOvV2va8n8izky9pyMGcKEaWkGAOFwUvDaLM=;
        b=GU5jRikfIiuufcSKpitPOIziRdYbH/1s6/PlXX3BUzMRWjabH/4LI68tpLtoXgdVKd
         rPySW9TWPtifGSwHP3URA/iJ1hOGBXuuQ4AUThJIvdNq/k8YSjYt2GH2Jz86RALaG3HD
         mZmHEkdbGFGVnWc6wQectHdd5Yfr0jSXeyvXRLZvROj1lo0HDk9Ab15mY0acJqimRCKo
         c2kJFDA3UBznGw33IvtQ/mzml2vOQk9z5L/TO6+6jI4XpCKh+EeS1FtjdGtAKQM+nwBV
         IkCwKXOkPSGnBqF/mtbwu1hIAHLuPuKdAGHixMX0ZGkto3CBaFGJpd1Z71xHKZRSKvih
         cGyg==
X-Gm-Message-State: APjAAAWL9rpJrSdJ81m9EeaxdHo4oUH8rQBISREvAgxC9PW9onzjPhFy
        yIJrMqvFuD1dtwTeDIFMejumsSdD2RV4lptjK+0fsQ==
X-Google-Smtp-Source: APXvYqxEw+T67xtMi2wE73YFSN6H47fGQq0YtfGOxlpdHJulo68SSkQ/xgXFUrLTR79+oTvvf7oEuSI3rmiddszWico=
X-Received: by 2002:a6b:ee07:: with SMTP id i7mr2506947ioh.26.1572907367672;
 Mon, 04 Nov 2019 14:42:47 -0800 (PST)
MIME-Version: 1.0
References: <20191029210555.138393-1-aaronlewis@google.com> <20191029210555.138393-3-aaronlewis@google.com>
In-Reply-To: <20191029210555.138393-3-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 4 Nov 2019 14:42:36 -0800
Message-ID: <CALMp9eSGMLfPEZtbChictusdMPnWB2wLvzuSY0K-5O-CoaGUBQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] kvm: vmx: Rename NR_AUTOLOAD_MSRS to NR_MSR_ENTRIES
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 29, 2019 at 2:06 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Rename NR_AUTOLOAD_MSRS to NR_MSR_ENTRIES.  This needs to be done
> due to the addition of the MSR-autostore area that will be added later
> in this series.  After that the name AUTOLOAD will no longer make sense.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Change-Id: Iafe7c3bfb90842a93d7c453a1d8c84a48d5fe7b0
Drop the Change-Id.

Reviewed-by: Jim Mattson <jmattson@google.com>
