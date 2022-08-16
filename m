Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C69595ADD
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 13:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbiHPLyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 07:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234335AbiHPLxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 07:53:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3656696FE0
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 04:29:57 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GANRu4001268
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 11:29:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : subject : from : message-id : date; s=pp1;
 bh=GKJh5AU0vsMLXQm+lsKRbNF1sEEHMShQX8WipYzP4yk=;
 b=nSlk691svSMTRzLOZ84Cy6jCvOH78vq0fNd4Akso3l/wMx0DgWFNw/KTvJmWTfDLelDq
 gtCZ0vMCt2WzM3E+bYx7DqoiYcIbGw9QsA8hrluneHoPYOrW9uQwuFHr8+gQ7K69LgLf
 d5nQ3r0hZb2yNE5H8yeASr0OExK5ioMHHYZ09wD7Q6HHWOAY0jj9KW/BjcRRqOCcp1i3
 cyXairQqbsEzToigwhi7LHBRXr8S+roBlnmrOXa/USpTxUASaGe1s1isCB0pENq8ZTxM
 787zFF0zKTE8WGwz5m12pnGZ7FgtP+ewIdp8Re3URQDctDR8SchtCwJAiWFJd9nJiAH9 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j09eqhk34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 11:29:56 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27GAUKwT029919
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 11:29:56 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j09eqhk2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 11:29:56 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27GBKShU020321;
        Tue, 16 Aug 2022 11:29:54 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3hx3k9b4km-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 11:29:54 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27GBTpjN28508596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 11:29:51 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72B815204F;
        Tue, 16 Aug 2022 11:29:51 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.69.74])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 07E685204E;
        Tue, 16 Aug 2022 11:29:50 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220812112912.3cd788f0@p-imbrenda>
References: <20220812062151.1980937-1-nrb@linux.ibm.com> <20220812062151.1980937-4-nrb@linux.ibm.com> <20220812112912.3cd788f0@p-imbrenda>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 3/4] s390x: add extint loop test
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <166064938984.58462.5303740579121882308@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Tue, 16 Aug 2022 13:29:49 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Par0oH9PuO6KblCbqzDWT4IQwUG50Y3Q
X-Proofpoint-GUID: PvZTOvrMGhfYfhakQSXvNg5dY_CpjZAE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_07,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=947
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-08-12 11:29:12)
> On Fri, 12 Aug 2022 08:21:50 +0200
> Nico Boehr <nrb@linux.ibm.com> wrote:
[...]
> > diff --git a/s390x/panic-loop-extint.c b/s390x/panic-loop-extint.c
> > new file mode 100644
> > index 000000000000..79d3f84a89ff
[...]
> > +int main(void)
> > +{
> > +     report_prefix_push("panic-loop-extint");
> > +
> > +     if (!host_is_qemu() || host_is_tcg()) {
> > +             report_skip("QEMU-KVM-only test");
> > +             goto out;
> > +     }
> > +
> > +     expect_ext_int();
> > +     lowcore.ext_new_psw.mask |=3D PSW_MASK_EXT;
> > +
> > +     load_psw_mask(extract_psw_mask() | PSW_MASK_EXT);
>=20
> you can use the recently introduced psw_mask_set_bits(PSW_MASK_EXT)

Done thanks.
