Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA4B70687E
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 14:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbjEQMoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 08:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbjEQMoO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 08:44:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C951FFC;
        Wed, 17 May 2023 05:44:13 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HCfodL025002;
        Wed, 17 May 2023 12:44:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : subject : from : message-id : date; s=pp1;
 bh=bk6LeFqmKu3jK5Ome10pI33jMM9lBbDMUp1SWFjjit4=;
 b=Phz54rexshhaTxfF2AHjmkA7psGg7TpiIidRWs1R7zL+kANZMC1NFKt3EwQCHf1tzeNr
 RAqv9cMOnxanFlOcvJ9ReP18hNkwb2nvPq/TjejJUghTfzwHDn/8NVh2F0nD66/E/JD4
 zYVisejCK9iC/Kdpnm9xFD3wyOaoswkiZCw2NTUEXtyGMTINFxaJjx7I3AZOoFPYBogR
 5lUj9pDxxbZ72nA/i5pQ8+rjnqzCFOVGZUEDIdYMWuoSmi7TX434/rIPB4+URf5e+1ZR
 anaa3XKYUk1jI6WbE0K1YYMBXTxaBWeuSrd8KsCrpa/8JDPZqV7J/dyvIMH6ahb1LhGx ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qmy5fr332-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 May 2023 12:44:12 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34HCgJfP026848;
        Wed, 17 May 2023 12:44:12 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qmy5fr31n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 May 2023 12:44:12 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34HCZqSY020190;
        Wed, 17 May 2023 12:44:09 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qj264t69v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 May 2023 12:44:09 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34HCi64R22413854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 12:44:06 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 464B42004B;
        Wed, 17 May 2023 12:44:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C7D12006E;
        Wed, 17 May 2023 12:44:06 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.7.234])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 17 May 2023 12:44:05 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230516192225.2b4eea48@p-imbrenda>
References: <20230516130456.256205-1-nrb@linux.ibm.com> <20230516130456.256205-3-nrb@linux.ibm.com> <20230516192225.2b4eea48@p-imbrenda>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/6] s390x: sie: switch to home space mode before entering SIE
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <168432744557.12463.11781289128593182833@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 17 May 2023 14:44:05 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oNziwPu6dR-fVvcTcMPKRCnOqcv8TqPl
X-Proofpoint-ORIG-GUID: RAJs8zTIO4FdZA9jVCxWQa-PnW-kL7Vh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-17_02,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305170103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2023-05-16 19:22:25)
[...]
> > diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> > index 147cb0f2a556..0b00fb709776 100644
> > --- a/lib/s390x/sie.h
> > +++ b/lib/s390x/sie.h
> > @@ -284,5 +284,6 @@ void sie_handle_validity(struct vm *vm);
> >  void sie_guest_sca_create(struct vm *vm);
> >  void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t gues=
t_mem_len);
> >  void sie_guest_destroy(struct vm *vm);
> > +bool sie_had_pgm_int(struct vm *vm);
>=20
> what's this?

Opsie, fixed :)
