Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E5D76A984
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 08:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbjHAGvp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 02:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbjHAGvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 02:51:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420DB98;
        Mon, 31 Jul 2023 23:51:43 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3716mgAW016449;
        Tue, 1 Aug 2023 06:51:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : cc : to : subject : message-id : date; s=pp1;
 bh=jaK/pRmw/+5njGqW7YJg96mQiDtsZWn3h6xVj/JQ8jY=;
 b=VQYA8xh78Oxc184GseMDv5mi/G4vLofuaevsJku/J5GjLhstQ4E9/4tnRBaAYLabJnLt
 WzAmHIKGsRCo6PsNucTaeufb5xiuONCAS+ry/mACioqtGhdoZ7U+DU1jfyLOBb6F1lGr
 UJ3dgnH+z9Ve1+8/ztcWatRCcOqjn+eE7L4h/QjehbnJ/gVlvE6hnVImUYEBLrxlUhSk
 lYQHi5/ngKpPm5W2xXIPjwvaSwI5vOlMTSqojf20OUviQbN7IbKcnLKw+otzepQBxdEp
 ua0DAwFMkX4uL+3jyCekY3KPEBK8y++2VqJMm2AbevyZGGqcJwADuKDOoqaiupC3S+J9 rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s6w42026s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Aug 2023 06:51:42 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3716pI52025117;
        Tue, 1 Aug 2023 06:51:42 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s6w420268-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Aug 2023 06:51:42 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3716U8bh015481;
        Tue, 1 Aug 2023 06:51:41 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s5e3mspb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Aug 2023 06:51:41 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3716pb6S28639752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Aug 2023 06:51:38 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D64C32004B;
        Tue,  1 Aug 2023 06:51:37 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7C3420043;
        Tue,  1 Aug 2023 06:51:37 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.7.232])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  1 Aug 2023 06:51:37 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <000b74d7-0b4f-d2b5-81b4-747c99a2df42@redhat.com>
References: <20230712114149.1291580-1-nrb@linux.ibm.com> <20230712114149.1291580-7-nrb@linux.ibm.com> <1aac769e-7523-a858-8286-35625bfb0145@redhat.com> <168932372015.12187.10530769865303760697@t14-nrb> <fd822214-ce34-41dd-d0b6-d43709803958@redhat.com> <168933116940.12187.12275217086609823396@t14-nrb> <000b74d7-0b4f-d2b5-81b4-747c99a2df42@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
To:     Thomas Huth <thuth@redhat.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v5 6/6] s390x: add a test for SIE without MSO/MSL
Message-ID: <169087269702.10672.8933292419680416340@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 01 Aug 2023 08:51:37 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2ppje1aBdvbitkwMX0XnLvfamP7Cxrw6
X-Proofpoint-ORIG-GUID: bsnaUg_hwV15V_IFYzDpt2_Zcl4TEAPD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-01_03,2023-07-31_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 mlxscore=0 spamscore=0
 mlxlogscore=827 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2306200000 definitions=main-2308010059
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2023-07-14 12:52:59)
[...]
> Maybe add $(SRCDIR)/s390x to INCLUDE_PATHS in the s390x/Makefile ?

Yeah, that would work, but do we want that? I'd assume that it is a
concious decision not to have tests depend on one another.
