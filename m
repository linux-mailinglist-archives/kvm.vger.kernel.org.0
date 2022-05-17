Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3B852A18A
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 14:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345472AbiEQM3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 08:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiEQM3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 08:29:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18E6496AF;
        Tue, 17 May 2022 05:29:37 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HCFrJp017352;
        Tue, 17 May 2022 12:29:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=rmFuzkE5F7RcXl6ndTqPBBlZWlxwqwGJL9XYG1XVxxo=;
 b=q0jXI/aYN5Ct3fx0b2opOJDx+T6O03bFdbHfOTyVhKqHdKl6FqyTsdxOLwfRulkfAJvX
 Ai1MIAd85uHshjHrEf4S99ENClY5QIKO2jdcvBmMHxBGJWtf9tU/a7ZOhbpG7B+wBWDd
 f5ap1CAaK0+9ZN0fPwq3+/C6NC1pJOlGn/+ijmMOsytOM7TayILZF2BUIWDcfr0UnY0m
 P7MJ+GM5w+E+KuvDQx1Zc4iJ7yTowaJ0hP7zS+sHHzcG42kIEFHP94otnqSk7447xGF/
 rmEhl739urPRTflmqOClLqCki0BtscKYgdy5y8AwWyAHaBrE6qDCxCnq2ibmq9EtjBOl gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4bjdgb7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 12:29:37 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HCTadE028505;
        Tue, 17 May 2022 12:29:36 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4bjdgb6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 12:29:36 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HCNjDf026998;
        Tue, 17 May 2022 12:29:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3g2428ubwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 12:29:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HCTVcZ43713006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 12:29:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40A3142042;
        Tue, 17 May 2022 12:29:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CC3642047;
        Tue, 17 May 2022 12:29:31 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 12:29:30 +0000 (GMT)
Date:   Tue, 17 May 2022 14:29:29 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: add migration test for
 storage keys
Message-ID: <20220517142929.62892902@p-imbrenda>
In-Reply-To: <bceaae6a24324cdb72056977fd6bf7916adcc9d7.camel@linux.ibm.com>
References: <20220516090702.1939253-1-nrb@linux.ibm.com>
        <20220516090702.1939253-2-nrb@linux.ibm.com>
        <947af627-64e0-486d-18e2-c877bc4c4ba6@linux.ibm.com>
        <3ab95d5d553362a686b9526c8b53996dcaf20400.camel@linux.ibm.com>
        <bceaae6a24324cdb72056977fd6bf7916adcc9d7.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0kV6nTHkk7J5yY6DyDDSos8TmWazJt3V
X-Proofpoint-ORIG-GUID: GlKhW9kes-7Epyy8WyA2bPaio6qTivDO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_02,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 mlxlogscore=712 clxscore=1015
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205170073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 May 2022 13:44:51 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> On Tue, 2022-05-17 at 10:17 +0200, Nico Boehr wrote:
> > On Mon, 2022-05-16 at 18:47 +0200, Janis Schoetterl-Glausch wrote: =20
> > > On 5/16/22 11:07, Nico Boehr wrote: =20
>=20
> [...]
>=20
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0expected_key.val =3D i * 2;
> > > > +
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0/* ignore reference bit */ =20
> > >=20
> > > Why? Are there any implicit references I'm missing? =20
> >=20
> > Since the PoP specifies (p. 5-122):
> >=20
> > "The record of references provided by the reference
> > bit is not necessarily accurate. However, in the major-
> > ity of situations, reference recording approximately
> > coincides with the related storage reference."
> >=20
> > I don't really see a way to test this properly.
> >=20
> > Maybe I missed something? =20
>=20
> No I think you're right, although in practice the reference bits should
> match. Or did you observe a mismatch?

the point is that the architecture allows for mismatches (in particular
I think it is allowed to overindicate changes)

ignoring that bit is the correct thing to do
