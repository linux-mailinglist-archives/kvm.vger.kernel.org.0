Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF666FC9A3
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 16:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235976AbjEIOzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 10:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbjEIOzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 10:55:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5290359A;
        Tue,  9 May 2023 07:54:56 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 349Eqvof007791;
        Tue, 9 May 2023 14:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : from : to : message-id : date; s=pp1;
 bh=i6Ke7L9GAof48s4hB2ciFrWAsUBqig3FATZy0dboBrQ=;
 b=YV3BIGsjoIrfWk+1EfAag8+iV81rj6JVv5Z4bHLCQN88KdyCvRRD3z2/+HwnlgOdsfGC
 3SWkUliLVbReaUSABejF7UisAW2td78zQ9hXz7BMZgNPikrFKCxcYjdT0rq+iPAXqMeb
 1VPeh3xZ18dDL2mpkzf9EK95S8xgFrwEhzQWA7GJ1bardzNgZ6mQZtFLtVjURA9rJXN3
 LgNNoIDshR4OUBSO4rgup1rvfbj+h4SRcB17r2qkM/VEHOPEaCexUVOrYMzlnjBkBJ6+
 SUhtBfxZENJJRgNNqbCNX/m7uKFxYkB+AbM6w1Sq+G7z7fpmGyV2fvMlTVv4pbvAVkxU bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfrb2023p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 14:54:55 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 349EstZN017513;
        Tue, 9 May 2023 14:54:55 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfrb2022r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 14:54:55 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 348N9h4V011689;
        Tue, 9 May 2023 14:54:53 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qf7nh0gxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 14:54:53 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 349EsnSo19989046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 May 2023 14:54:49 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9231C20043;
        Tue,  9 May 2023 14:54:49 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DE1520040;
        Tue,  9 May 2023 14:54:49 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.4.21])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  9 May 2023 14:54:49 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230509134839.2e243224@p-imbrenda>
References: <20230509111202.333714-1-nrb@linux.ibm.com> <20230509111202.333714-4-nrb@linux.ibm.com> <20230509134839.2e243224@p-imbrenda>
Subject: Re: [PATCH v1 3/3] KVM: s390: add tracepoint in gmap notifier
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <168364408907.331309.11611373136257111359@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 09 May 2023 16:54:49 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QfdZZuvztYxJmGe-A1fz_Jm4WzonYY_a
X-Proofpoint-ORIG-GUID: DDrJ0mvpuiiwFW0JuNgNc3q_5UQ86msf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=894
 mlxscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305090119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2023-05-09 13:48:39)
> On Tue,  9 May 2023 13:12:02 +0200
> Nico Boehr <nrb@linux.ibm.com> wrote:
>=20
> > The gmap notifier is called whenever something in the gmap structures
>=20
> this is a little bit too oversimplified; the gmap notifier is only
> called for ptes (or pmds for hugetlbfs) that have the notifier bit set
> (used for prefix or vsie)

Yep true, I will adjust, thanks.
