Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBE26EFE1E
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 01:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240955AbjDZX5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 19:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242555AbjDZX5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 19:57:34 -0400
Received: from mail.heimpalkorhaz.hu (mail.heimpalkorhaz.hu [193.224.51.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203B2269F
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 16:57:31 -0700 (PDT)
Received: from mail.heimpalkorhaz.hu (localhost [127.0.0.1])
        (Authenticated sender: alexandra.nagy@heimpalkorhaz.hu)
        by mail.heimpalkorhaz.hu (Postfix) with ESMTPA id B40B9381E35A1F;
        Thu, 27 Apr 2023 01:40:36 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.heimpalkorhaz.hu B40B9381E35A1F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heimpalkorhaz.hu;
        s=default; t=1682552437;
        bh=W6ZSce0cCVgkn0l95t889AY595zUPLw5BzNOdwdHQs8=;
        h=Date:From:To:Subject:Reply-To:From;
        b=Xb0QxSOTColJkb1gd5JdDkhAE52H7J93511IX9qtO43nqE/7raeuB03/VozOCo92i
         d8A+Oe5SHpOhrI9gAEDDCLldlDMJTXciy4TDJxJewCgT8F+vFiP3NBDw7styPw7pjW
         CFvl/6jSv/RVaXFK7GvD9D+EkiXItOw49riooySc4i6JXDvC4MRfa5I8XnMAKzwurm
         Et9pRx9yPiRfibsJW7SF9qya2wv535O17v2I7jA+5YbfOmVB9+sUjhMfkldX1WCpYv
         TlzdO1/tALZfLq8doMBFZzxjacuc/6Mm/yoDffYI8SaNKhkkmZRPmfSqfW9q6GmTdW
         hrQREA++65hCQ==
MIME-Version: 1.0
Date:   Thu, 27 Apr 2023 07:40:36 +0800
From:   "M.K" <mk@heimpalkorhaz.hu>
To:     undisclosed-recipients:;
Subject: =?UTF-8?Q?=E4=BD=A0=E5=A5=BD=E9=99=BD=E5=85=89?=
Reply-To: kmarion709@gmail.com
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <da83b6ea00f23f93dc5824a58504c3d5@heimpalkorhaz.hu>
X-Sender: mk@heimpalkorhaz.hu
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B40B9381E35A1F
X-Spamd-Result: default: False [4.31 / 20.00];
        R_UNDISC_RCPT(3.00)[];
        FORGED_RECIPIENTS(2.00)[m:,s:kovmihser@yandex.ru,s:kovofbm981138582@sohu.com,s:kovrikleo@mail.ru,s:kovyi@seznam.cz,s:kovyin@centrum.cz,s:kowallis_5423@163.com,s:kowny@tom.com,s:kowomba@yahoo.com,s:kowsalyabalaji@gmail.com,s:kowtgu@yahoo.com,s:kox20m42y@sohu.com,s:kox64m84y@sohu.com,s:koxik@centrum.cz,s:koxln51lpf5x@sohu.com,s:koxt4a2h@sohu.com,s:koy-goodxiaosong@163.com,s:koy9104@163.com,s:koyard@yahoo.cn,s:koyo168@163.com,s:koyoni@gmail.com,s:koyozl@sohu.com,s:koys60@hotmail.com,s:kozachenko174@mail.ru,s:kozence@gmail.com,s:kozerog1121@mail.ru,s:kozl20gris@gmail.com,s:kozlovdmutrui2001@mail.ru,s:kozubilya@mail.ru,s:kozy430@yahoo.co.jp,s:kp1003b@gmail.com,s:kp3r82zx@sohu.com,s:kp504@sohu.com,s:kp601824@sohu.com,s:kp791w1pk@sohu.com,s:kp@kyonproducts.com,s:kp_wu@163.com,s:kpadams@ihug.co.nz,s:kpaliy.airshot@mail.ru,s:kpathana@mail.med.cmu.ac.th,s:kpatterson@dadeschools.net,s:kpattersonrocks@aol.com,s:kpavonncm@gmail.com,s:kpb26@cam.ac.uk,s:kpbagley@hotmail.com,s:kpc826-921@sohu.com,s
 :kpc@theia.ocn.ne.jp,s:kpcorb@aol.com,s:kpcrxg@sohu.com,s:kpe8166@sohu.com,s:kpeggs@gmail.com,s:kperkins@dadeschools.net,s:kpfraind@gmail.com,s:kpg082885@sohu.com,s:kpgqhjyrz@yahoo.cn,s:kphbdnc30@qq.com,s:kphitn62@sohu.com,s:kphumiao@sina.com,s:kphw23k@sohu.com,s:kphxbobh@sohu.com,s:kpj2013@sohu.com,s:kpk564@sohu.com,s:kpkant@hotmail.com,s:kpking@126.com,s:kplee@iaeperth.com,s:kpli@bjtu.edu.cn,s:kplim1616@gmail.com,s:kpm0093@163.com,s:kpm1961@gmail.com,s:kpmail2@163.com,s:kpmpalanivel@gmail.com,s:kpnoehou@qq.com,s:kpob9lk@tut.by,s:kpodar_e@yahoo.com,s:kpogkr@yahoo.com,s:kpogod@yahoo.com,s:kpoohs19@yahoo.com,s:kpouridas458@gmail.com,s:kpowell@old-cutler.com,s:kpqcrypto@gmail.com,s:kpqsbjfyj@163.com,s:kpt1619@163.com,s:kptaylor@xtra.co.nz,s:kpysxtz@hotmail.com,s:kq101924@163.com,s:kq147258@163.com,s:kq5052@163.com,s:kqdengxuliang@bjmu.edu.cn,s:kqds_md@yahoo.com,s:kqgszym@163.com,s:kql655@163.com,s:kqqkqqqi@126.com,s:kqstxu@yahoo.cn,s:kquinalty@hotmail.com,s:kquintin@uoregon.edu,s:kqw@
 ere.com.my,s:kqxyyh@163.com,s:kqykqy413@sohu.com,s:kqyuzhen@163.com,s:kqzl222626@yahoo.cn];
        GENERIC_REPUTATION(-0.59)[-0.58799365293623];
        MIME_GOOD(-0.10)[text/plain];
        TAGGED_RCPT(0.00)[];
        FROM_EQ_ENVFROM(0.00)[];
        RCVD_COUNT_ZERO(0.00)[0];
        MIME_TRACE(0.00)[0:+];
        FROM_HAS_DN(0.00)[];
        FREEMAIL_ENVRCPT(0.00)[yandex.ru,sohu.com,mail.ru,seznam.cz,centrum.cz,163.com,tom.com,yahoo.com,gmail.com,yahoo.cn,hotmail.com,yahoo.co.jp,aol.com,qq.com,sina.com,126.com,tut.by,xtra.co.nz,me.com,web.de,rediff.com,op.pl,yahoo.it,rambler.ru,hotmail.it,comcast.net,ymail.com,live.com.au,live.com,rocketmail.com,verizon.net,icloud.com,msn.com,hotmail.fr,interia.pl,wp.pl,naver.com,aim.com,hotmail.co.uk,inbox.ru,bellsouth.net,hanmail.net,yahoo.com.cn,21cn.com,cox.net,vip.163.com,yeah.net,arcor.de,yahoo.ca,china.com,live.dk,bk.ru,yahoo.co.in,rediffmail.com,gmx.net,freenet.de,yahoo.co.nz,freemail.hu,list.ru,singnet.com.sg,ozemail.com.au,optusnet.com.au,inwind.it,vip.qq.com];
        TO_DN_ALL(0.00)[];
        MID_RHS_MATCH_FROM(0.00)[];
        RCPT_COUNT_ONE(0.00)[1];
        FREEMAIL_REPLYTO(0.00)[gmail.com];
        REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
        HAS_REPLYTO(0.00)[kmarion709@gmail.com]
X-Rspamd-Server: mail.heimpalkorhaz.hu
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

你好呀，

很抱歉打擾您並侵犯您的隱私。 我是單身，孤獨，需要一個關懷，愛心和浪漫的伴侶。

我是一個暗戀者，想探索更多了解彼此的機會。 我知道這樣聯繫你很奇怪，希望你能原諒我。 我是一個害羞的人，這是我知道我能引起你注意的唯一方式。 
我只是想知道你的想法，我的本意不是要冒犯你。 我希望我們能成為朋友，如果那是你想要的，儘管我希望不僅僅是朋友。 
我知道你有幾個問題要問，我希望我能用一些答案來滿足你的一些好奇心。

我相信“對於世界來說，你只是一個人，但對於特別的人來說，你就是全世界”這句話。 我想要的只是來自一個特殊伴侶的愛、浪漫的關懷和關注，我希望是你。

我希望這條消息將成為我們之間長期溝通的開始。 感謝您回复此消息，因為這會讓我很高興。


擁抱，

你的秘密崇拜者。
