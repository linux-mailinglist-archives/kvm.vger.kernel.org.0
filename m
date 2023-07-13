Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC50752757
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 17:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbjGMPgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 11:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232637AbjGMPgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 11:36:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE091FF1;
        Thu, 13 Jul 2023 08:35:47 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DFWpvB027360;
        Thu, 13 Jul 2023 15:35:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : subject : cc : message-id : date; s=pp1;
 bh=Gc8hpmoTAOu+D/IjBBiPCG2OkjQY1aNNFOMGP3brvN4=;
 b=YTFEKfGPXVjeF99xTKX8xgazQ6MBhPYbNiwAIEgx2Zzy9HLFuiDHZPTXFqmR2ySGMgAb
 RSqAL7/KmBs4CGq2KaEpFYT6LXDLvajHSysbAcNZNxiyJ4e/QH9A4rI11rfdjdB9Vxph
 1vBl7ilzWnZ58t+UE6SVDC21nJI/XZVFd6H1kYAWVfbMADzQLqTKC6Rj5IEfCLqVkvAi
 Fz7QB9fUBExFxNw6rZOCZ89GEuR5u4OsjJJ9NA2b8tyWdMYxeSgo+iwrcQbXVhvflfn3
 UcHFyMAjf2JgcJ/TMDd9dYvjztWuSmshCjl8w4g9KiRQ0odHvRP0PxO1iRXaNolvRZit kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rtksdgjan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 15:35:46 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36DFHua7007383;
        Thu, 13 Jul 2023 15:35:46 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rtksdgj6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 15:35:46 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36DDYnUJ008210;
        Thu, 13 Jul 2023 15:35:41 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3rpye5advw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 15:35:41 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36DFZWgh2818706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 15:35:32 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72AC820043;
        Thu, 13 Jul 2023 15:35:32 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EB2A2004B;
        Thu, 13 Jul 2023 15:35:32 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.87.199])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jul 2023 15:35:32 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230713102413.214d37b3@p-imbrenda>
References: <20230712114149.1291580-1-nrb@linux.ibm.com> <20230712114149.1291580-3-nrb@linux.ibm.com> <20230713102413.214d37b3@p-imbrenda>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 2/6] s390x: add function to set DAT mode for all interrupts
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Message-ID: <168926253197.12187.8091392446597591392@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 13 Jul 2023 17:35:31 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R7q0fiEs5RgxsOodx9vuaOFKn-G_9puW
X-Proofpoint-GUID: S8KUgww9kXgYSqTjVVzcIiSRbuQBk2kB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_06,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 bulkscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0 mlxlogscore=757
 mlxscore=0 priorityscore=1501 adultscore=0 impostorscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307130137
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2023-07-13 10:24:13)
> On Wed, 12 Jul 2023 13:41:45 +0200
> Nico Boehr <nrb@linux.ibm.com> wrote:
>=20
> [...]
>=20
> > +/**
> > + * irq_set_dat_mode - Set the DAT mode of all interrupt handlers, exce=
pt for
> > + * restart.
> > + * This will update the DAT mode and address space mode of all interru=
pt new
> > + * PSWs.
> > + *
> > + * Since enabling DAT needs initalized CRs and the restart new PSW is =
often used
> > + * to initalize CRs, the restart new PSW is never touched to avoid the=
 chicken
> > + * and egg situation.
> > + *
> > + * @dat specifies whether to use DAT or not
> > + * @as specifies the address space mode to use - one of AS_PRIM, AS_AC=
CR,
>=20
> please mention here that  as  will not be set if  dat =3D=3D false

Right, done.
