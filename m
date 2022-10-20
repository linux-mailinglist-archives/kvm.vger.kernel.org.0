Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBECD60592B
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 09:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiJTH6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 03:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiJTH6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 03:58:14 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5295C17FD7D
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 00:58:12 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K7hkrn022078
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 07:58:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : to : from : message-id : date; s=pp1;
 bh=jEBliKQsrfuftkgXdKnYjRBbEVjkn3aRhSEfHpXlxUM=;
 b=NxiBkiu3WHgBDQwkiyuk3bpwhOd3VJUW/lNqSTwQCM5rrsfjKszCgeEwonreE3dauA9n
 KWPUZYumnXuhaiTqAUXamm233rOGjVBic3lHIDBPX0YhAQSTKCr9njnZxFi/+X5+yxM7
 ipVHTlUUqE9C0KP80Vqc9UIsvXHTTsJ0GeOxqMGpNTGlg1ysNXz5kMKykmOgf4mE9uIR
 ZNH/IFpdFr7dKF7E1qFaMWlxS5uPL06fXrRqBXK2nbZEMuo/ksPqhg/vE4nDcnLrd38r
 i5MHBq90CwVKZV8XyhdyEJP7w1qoWeUrDFcuJjaxM0rcCuNBOehfvnlOVV3Kqb2+pB2Z HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb26r8bjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 07:58:11 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29K7jiZg027863
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 07:58:11 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb26r8bhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 07:58:10 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29K7oMYG019326;
        Thu, 20 Oct 2022 07:58:09 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3kajmrs76v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 07:58:09 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29K7w6bX62980586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 07:58:06 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF22942042;
        Thu, 20 Oct 2022 07:58:05 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D60A04203F;
        Thu, 20 Oct 2022 07:58:05 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.203.253])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 07:58:05 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221019115128.2a8cbf13@p-imbrenda>
References: <20221018140951.127093-1-imbrenda@linux.ibm.com> <20221018140951.127093-2-imbrenda@linux.ibm.com> <166616486603.37435.2225106614844458657@t14-nrb> <20221019115128.2a8cbf13@p-imbrenda>
Subject: Re: [kvm-unit-tests PATCH v1 1/2] lib: s390x: terminate if PGM interrupt in interrupt handler
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <166625268562.6247.14921568293025628326@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 20 Oct 2022 09:58:05 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 79WqfqDKyExdpH5UmGkd4xjaB7RCB8il
X-Proofpoint-ORIG-GUID: jJHNauQd3NbUZ_o-zrtjnN8awrkGHbFx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_01,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 mlxlogscore=539 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210200043
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-10-19 11:51:28)
[...]
> I was thinking that we set pgm_int_expected =3D false so we would catch a
> wild program interrupt there, but in hindsight maybe it's better to set
> in_interrupt_handler =3D true there so we can abort immediately

Oh right I missed that. I think how it is right now is nicer because we wil=
l get a nice message on the console, right?

In this case:
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
