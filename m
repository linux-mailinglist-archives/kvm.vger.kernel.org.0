Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD35760065
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 22:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjGXUUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 16:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjGXUUL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 16:20:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBB2C6
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 13:20:10 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36OKJNLM006935;
        Mon, 24 Jul 2023 20:19:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=PfnL3R+qEZCZVDaIkeGd2c+3Igum6OKlfRNXkvpqkY0=;
 b=gSkCxi7fiuh9Ci62q5gnVxhmh2f6P9M2NyFx1/Oy3dmj7lb13/nf3BroPd/9MkdfLxyS
 ojBwIKFFYfxtYymSYtHXrn1vMkjR8xzTmS7M5rbbH+2cRpiYiw/xZJvCbIo0IdaBq/0b
 4/53ua5StpncldhIvBQKCv00tUPj0NrbnuKZBG2w8F82kKO85fneSsTWO+MVinLX7Gze
 To1K3ODZk9PrF3e9t34nLkI4AWWGQWmWNXjoi6iMpE7GsL86menQEnp47JQ9+8awMmoq
 9efTCLExMrJltjna8mNY30NbcOEHvDgoQ/x8N2JR4TY2oB3lEt0FU8yZQ1UQx4cW/MaD tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s1yfyha6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 20:19:56 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36OK9mPg032705;
        Mon, 24 Jul 2023 20:19:55 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s1yfyha6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 20:19:55 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36OImboO002132;
        Mon, 24 Jul 2023 20:19:54 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3s0unj5s2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 20:19:54 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36OKJoAv40305366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 20:19:50 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4893F20040;
        Mon, 24 Jul 2023 20:19:50 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1497D20043;
        Mon, 24 Jul 2023 20:19:49 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.57.141])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jul 2023 20:19:48 +0000 (GMT)
Message-ID: <0743d96760a7b3d8d79ed1443c26896eac6a1a13.camel@linux.ibm.com>
Subject: Re: [PATCH v21 02/20] s390x/cpu topology: add topology entries on
 CPU hotplug
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Mon, 24 Jul 2023 22:19:48 +0200
In-Reply-To: <20230630091752.67190-3-pmorel@linux.ibm.com>
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
         <20230630091752.67190-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Z1gh6oVG4xA0zi_i9CUIXUrgR3h2dohV
X-Proofpoint-GUID: HUZV-ztbkWY1UQtz6IF0qz6EsRFuX7yu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_16,2023-07-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240176
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-06-30 at 11:17 +0200, Pierre Morel wrote:
> The topology information are attributes of the CPU and are
> specified during the CPU device creation.
>=20
> On hot plug we:
> - calculate the default values for the topology for drawers,
> =C2=A0 books and sockets in the case they are not specified.
> - verify the CPU attributes
> - check that we have still room on the desired socket
>=20
> The possibility to insert a CPU in a mask is dependent on the
> number of cores allowed in a socket, a book or a drawer, the
> checking is done during the hot plug of the CPU to have an
> immediate answer.
>=20
> If the complete topology is not specified, the core is added
> in the physical topology based on its core ID and it gets
> defaults values for the modifier attributes.
>=20
> This way, starting QEMU without specifying the topology can
> still get some advantage of the CPU topology.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com> if you address
Thomas' comments.

