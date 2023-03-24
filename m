Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8196C7A59
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 09:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbjCXIx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 04:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbjCXIxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 04:53:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C435619F15;
        Fri, 24 Mar 2023 01:53:12 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32O8BoWV000552;
        Fri, 24 Mar 2023 08:53:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=C3o3DjGSyucKEFmssF3kdwJIybeouD/Z5wrMZX/Mtew=;
 b=s7qVXg9pebnH2/Ls5X3jqSym8FC2pfIT+cJKmKnOKF5mqq9Lz8DvwQKIxv3BgNJir4pv
 FUs/Qf4Z+uGICsAWcdoOkAtj9qO5/UBXDpuwQygpAjUDElxzoQtCgfmfJG5pTK1pA4hG
 HOglLnGmC/NsLTrec9VCfaM9DQov7GSOURmK3q3kXWuBIZUIgoKq/2DhMDTOcQme5xd4
 6pkmmsssUWarR2wH51y1eU3z6Lxm81zGl7aqAtEE9GdAnvfUouNq1yHOyrxkr5iYN18C
 8CMvXsSOtdcD0AOorePHml7Y10KJNz4IcRVPeQyPT0A+0n9gie8TsymLf+wQtqWfDud4 WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ph84rru44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 08:53:12 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32O8D56x007868;
        Fri, 24 Mar 2023 08:53:11 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ph84rru32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 08:53:11 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NLulUh013860;
        Fri, 24 Mar 2023 08:53:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pgy3s0jsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 08:53:09 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32O8r53943319862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 08:53:05 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA02720043;
        Fri, 24 Mar 2023 08:53:05 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 862CB20040;
        Fri, 24 Mar 2023 08:53:05 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.14.197])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 08:53:05 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221208170502.17984-1-thuth@redhat.com>
References: <20221208170502.17984-1-thuth@redhat.com>
Cc:     linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests v2 PATCH] s390x: sie: Test whether the epoch extension field is working as expected
Message-ID: <167964798514.41638.4789907314697265732@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 24 Mar 2023 09:53:05 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iSKWNxplSCd9XGBgAbWsmuplhVxhZkJu
X-Proofpoint-GUID: C6CBdwj-kUjGEoJYLDt1ZmFuhukMkzV8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_04,2023-03-23_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=874 priorityscore=1501 clxscore=1015 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240070
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2022-12-08 18:05:02)
> We recently discovered a bug with the time management in nested scenarios
> which got fixed by kernel commit "KVM: s390: vsie: Fix the initialization
> of the epoch extension (epdx) field". This adds a simple test for this
> bug so that it is easier to determine whether the host kernel of a machine
> has already been fixed or not.
>=20
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Thanks, I have pushed this to our CI and will queue it as soon as it's stab=
le there.
