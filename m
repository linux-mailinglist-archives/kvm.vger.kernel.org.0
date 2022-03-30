Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B32F4ECBEE
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 20:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350207AbiC3S0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 14:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350014AbiC3S0H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 14:26:07 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF722473BA
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 11:23:26 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id d30so4481365pjk.0
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 11:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=6PnxJaVdYHTfEoSreao3ANO+XeqxY/p/4dxKSObIH1I=;
        b=UzHYyDJVpjqyJnDiWCRzZ5b9Uz7QE+WHua4j6nPFECz1IH6EyN1FhXUJDz8YBw1uOo
         TxDbv8775KdWQPi5Biar1UcImrdOR2whNw9Zcd3bX4d+vI7OQauqzJxR82tvNJgf5RAk
         bjRZkB48amAN+bFFR1KiFkzamok/6bugeETfwFe2HM2yNA8Z0V/En6sanfD25h6AqF4n
         N+eRcgdjFiOanXtqbctqYBYgjevR0OQUXzn9AJ3UOtPyVeenWoYfqdMChBijmdIS2Vfs
         DDHExwSTNOIlxtYipaHiN1m29VeTo3oXugsX3SrG3twFFUfj/JsrtFAArVgm7vOHEuJ5
         iRAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=6PnxJaVdYHTfEoSreao3ANO+XeqxY/p/4dxKSObIH1I=;
        b=nT4HD8sd4oSH/MGTZ0a8Tmx9U+xNOKpsJlVkQnRypPJZYTRS+/MShRzAgjFZ9IJSYc
         L32qfT74bZW43pwlsfdxWulTJGztN2WXVYALTSEfkXnjtmgjaVr1PFyVkiAjC9gwMBj2
         ipGlgT/8oi7Br77m2fjM+iS2Juw+wKobasTNSWuSGGNiOmGYkZAgC9fqVMZtZvzuCoqy
         lXTyjP9lcdnnhRrgKSKch9ZE1yYyTpprqOzxW1+wte6hNY2Mi5PhwbEPqx+W5W10zY/Q
         e2cWFAD+k7ZWljTE/Xgxj7w6Sb1CzsR02DzYtZK6QPD71WnBdBZ1NUjyvRlYeyxKugTZ
         ddbA==
X-Gm-Message-State: AOAM531841Ho2tysfeEvp8SYZ2R8j1BUWGvGX1opprRb+kC7ZqCDaSce
        sC+wBduQuV3MlFc88NlPn8VWSCa54bCc4+8OGA==
X-Google-Smtp-Source: ABdhPJxSMkrcrNycV18yKBmbdCGUDiBXRPKp5ce96oIoaOAykoZLkAeOF7pJgeIoLgfTSHGZVNr2YVEaKFTqUZ4+1ek=
X-Received: by 2002:a17:903:240a:b0:14e:dad4:5ce4 with SMTP id
 e10-20020a170903240a00b0014edad45ce4mr932885plo.125.1648664605335; Wed, 30
 Mar 2022 11:23:25 -0700 (PDT)
MIME-Version: 1.0
Reply-To: isabellasayouba0@gmail.com
Sender: 040stherchurch@gmail.com
Received: by 2002:a05:6a20:691d:b0:76:6cf5:d552 with HTTP; Wed, 30 Mar 2022
 11:23:24 -0700 (PDT)
From:   Mrs Isabella Sayouba <isabellasayouba0@gmail.com>
Date:   Wed, 30 Mar 2022 18:23:24 +0000
X-Google-Sender-Auth: SJsKpyHKFq56xsTSXsC6FFvIWqc
Message-ID: <CAAzQq76CmXVvCfiN6S=5QGjsv76FkndNX7ueLWK7_FBfjJ8Yfg@mail.gmail.com>
Subject: =?UTF-8?B?44GC44GE44GV44Gk44CC?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=3.8 required=5.0 tests=BAYES_99,BAYES_999,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

44GC44GE44GV44Gk44CCDQoNCua2meOCkua1geOBl+OBquOBjOOCieOBk+OBruODoeODvOODq+OC
kuabuOOBhOOBpuOBhOOBvuOBmeOAguengeOBruebruOBq+OBr+Wkp+OBjeOBquaCsuOBl+OBv+OB
jOOBguOCiuOBvuOBmeOAguengeOBruWQjeWJjeOBr+OCpOOCtuODmeODqeODu+OCteODqOOCpuOD
kOOBleOCk+OBp+OBmeOAguODgeODpeODi+OCuOOCouWHuui6q+OBp+OAgeODluODq+OCreODiuOD
leOCoeOCveOBrueXhemZouOBi+OCiemAo+e1oeOCkuWPluOCiuOBvuOBmeOAguengeOBr+OBguOB
quOBn+OBq+W/g+OCkumWi+OBhOOBpuaEn+WLleOBl+OBn+OBruOBp+OAgeOBguOBquOBn+OBq+ip
seOBmeS7peWkluOBq+mBuOaKnuiCouOBr+OBguOCiuOBvuOBm+OCk+OAguengeOBr+OAgTIwMTHl
ubTjgavkuqHjgY/jgarjgovliY3jgavjg5bjg6vjgq3jg4rjg5XjgqHjgr3jga7jg4Hjg6Xjg4vj
grjjgqLlpKfkvb/jgag55bm06ZaT5YON44GE44Gm44GE44GfU2F5b3ViYQ0KQnJvd27msI/jgajn
tZDlqZrjgZfjgb7jgZfjgZ/jgILlrZDkvpvjgarjgZfjgacxMeW5tOmWk+e1kOWpmuOBl+OBn+OA
gg0KDQrlvbzjga/jgZ/jgaPjgZ815pel6ZaT57aa44GE44Gf55+t44GE55eF5rCX44Gu5b6M44Gn
5q2744Gr44G+44GX44Gf44CC5b2844Gu5q275b6M44CB56eB44Gv5YaN5ama44GX44Gq44GE44GT
44Go44Gr5rG644KB44G+44GX44Gf44CC5Lqh44GP44Gq44Gj44Gf5aSr44GM55Sf44GN44Gm44GE
44Gf44Go44GN44CB5b2844Gv57eP6aGNODUw5LiH44OJ44Or44KS6aCQ44GR44G+44GX44Gf44CC
DQrvvIg4MDDkuIc1MDAw44OJ44Or77yJ6KW/44Ki44OV44Oq44Kr44Gu44OW44Or44Kt44OK44OV
44Kh44K944Gu6aaW6YO944Ov44Ks44OJ44Kl44Kw44O844Gu6YqA6KGM44Gn44CC54++5Zyo44CB
44GT44Gu44GK6YeR44Gv44G+44Gg6YqA6KGM44Gr44GC44KK44G+44GZ44CC5b2844Gv44GT44Gu
44GK6YeR44KS44OW44Or44Kt44OK44OV44Kh44K944Gu6Ymx5qWt44GL44KJ44Gu6YeR44Gu6Ly4
5Ye644Gr5Yip55So44Gn44GN44KL44KI44GG44Gr44GX44G+44GX44Gf44CCDQoNCuacgOi/keOA
geengeOBruWMu+iAheOBr+engeOBjOeZjOOBqOiEs+WNkuS4reOBruWVj+mhjOOBruOBn+OCgeOB
qzfjg7bmnIjplpPjga/ntprjgYvjgarjgYTjgaDjgo3jgYbjgajnp4HjgavoqIDjgYTjgb7jgZfj
gZ/jgILnp4HjgpLmnIDjgoLmgqnjgb7jgZvjgabjgYTjgovjga7jga/ohLPljZLkuK3jga7nl4Xm
sJfjgafjgZnjgILnp4Hjga7nirbmhYvjgpLnn6XjgaPjgZ/jga7jgafjgIHnp4Hjga/jgZPjga7j
gYrph5HjgpLjgYLjgarjgZ/jgavmuKHjgZfjgabjgIHmgbXjgb7jgozjgarjgYTkurrjgIXjga7k
uJboqbHjgpLjgZnjgovjgZPjgajjgavjgZfjgb7jgZfjgZ/jgILjgYLjgarjgZ/jga/jgZPjga7j
gYrph5HjgpLnp4HjgYzjgZPjgZPjgafmjIfnpLrjgZnjgovmlrnms5XjgafliKnnlKjjgZnjgovj
gafjgZfjgofjgYbjgILnp4Hjga/jgYLjgarjgZ/jgavjgYLjgarjgZ/jga7lgIvkurrnmoTjgark
vb/nlKjjga7jgZ/jgoHjgavnt4/jgYrph5Hjga4zMOODkeODvOOCu+ODs+ODiOOCkuWPluOBo+OB
puassuOBl+OBhOOBp+OBmeOAguOBiumHkeOBrjcw77yF44Gv56eB44Gu5ZCN5YmN44Gn5a2k5YWQ
6Zmi44KS5bu644Gm44CB6YCa44KK44Gu6LKn44GX44GE5Lq644CF44KS5Yqp44GR44KL44Gf44KB
44Gr5L2/44GG44Gn44GX44KH44GG44CC56eB44Gv5a2k5YWQ44Go44GX44Gm6IKy44Gh44G+44GX
44Gf44GM44CB56We44Gu5a6244KS57at5oyB44GZ44KL44Gf44KB44Gg44GR44Gr44CB5a625peP
44Gr44Gv6Kqw44KC44GE44G+44Gb44KT44CC44GT44Gu55eF5rCX44GM56eB44KS44Go44Gm44KC
6Ium44GX44KB44Gf44Gu44Gn44CB56We44GM56eB44Gu572q44KS6LWm44GX44CB5qW95ZyS44Gn
56eB44Gu6a2C44KS5Y+X44GR5YWl44KM44KL44KI44GG44Gr44GT44KM44KS44GX44Gm44GE44KL
44Gu44Gn44GZ44CCDQoNCui/lOS/oeOCkuWPl+OBkeWPluOCiuasoeesrOOAgeODluODq+OCreOD
iuODleOCoeOCveOBrumKgOihjOOBrumAo+e1oeWFiOOCkuOBiuefpeOCieOBm+OBl+OBvuOBmeOA
guOBvuOBn+OAgemKgOihjOOBruePvuWcqOOBruWPl+WPluS6uuOBp+OBguOCi+OBk+OBqOOCkuio
vOaYjuOBmeOCi+aoqemZkOabuOOCkueZuuihjOOBmeOCi+OCiOOBhumKgOihjOmVt+OBq+aMh+ek
uuOBl+OBvuOBmeOAguengeOBjOOBk+OBk+OBp+i/sOOBueOBn+OCiOOBhuOBq+OBguOBquOBn+OB
jOOBneOCjOOBq+W/nOOBmOOBpuihjOWLleOBmeOCi+OBk+OBqOOCkuengeOBq+S/neiovOOBl+OB
puOBj+OBoOOBleOBhOOAgg0KDQrjgqTjgrbjg5njg6njg7vjgrXjg6jjgqbjg5DlpKvkurrjgYvj
gonjgIINCg==
