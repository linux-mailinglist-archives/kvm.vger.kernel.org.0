Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADA3E690EF8
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 18:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjBIROh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 12:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBIROg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 12:14:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAD6AD2F
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 09:14:35 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319H1kZP024067;
        Thu, 9 Feb 2023 17:14:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=lvSzpAz+N2vwasHmBwgxtzvNVnUWEG4aIwNbw07xED0=;
 b=iVuEBlOWzii20dv4km9NpZhFVdB7k2yE7FWUd+z8TmlOXgfl2D5en0zq6T6M0bjBQmAH
 PzhvD0Ljg5E1UgOlvIkyBqTjCJ+aXG/NPtEci4h+6tepHPXXVrR7hs5hYMbZthdClrNe
 eP5mxNV5RPH2PvuYR+GbR7jVcsBp1vBv+NmuYo6xX/MaTcZajYqKGnZAcx6vSPBLiKCo
 DRKU4CiQ4kQ8aTrH6thUQpA+O1LJ2HjjH0MqAOhr6m9IbRQt6L6/aFhe0x7UfmQRirc8
 wWQdTNHanjVMhuyQUbperIeGb6g+mxh3eNIh9sUdBTFyn0iiUoVVPzKeVzilmDISaU8i 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nn4vdgu8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 17:14:30 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 319H4ehU003535;
        Thu, 9 Feb 2023 17:14:29 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nn4vdgu82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 17:14:29 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 318L1Kd5016027;
        Thu, 9 Feb 2023 17:14:27 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3nhf06vm8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 17:14:27 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319HENl437486878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 17:14:23 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CEC920049;
        Thu,  9 Feb 2023 17:14:23 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D47420043;
        Thu,  9 Feb 2023 17:14:23 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.156.204])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Feb 2023 17:14:22 +0000 (GMT)
Message-ID: <74229e1f3cbb45a92e8b1f26cc8ad744453985a7.camel@linux.ibm.com>
Subject: Re: [PATCH v15 00/11] s390x: CPU Topology
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Thu, 09 Feb 2023 18:14:22 +0100
In-Reply-To: <20230201132051.126868-1-pmorel@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mAdlDBKcYxIUM7OgnKcYkxLXUieXUbS2
X-Proofpoint-GUID: aifQs9QIqiAsZg4xd5P5puPpuMwVUWTs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-09_13,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0 spamscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=998 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090162
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IMO this series looks good overall and like it's nearing the final stages.

You use "polarity" instead of "polarization" a lot.
Since the PoP uses polarization I think that term would be preferred.

With the series as it is, one cannot set the polarization via qmp,
only the entitlement of individual cpus. So only the VM can change
the polarization.
Would it be desirable to also be able to set the polarization from the outs=
ide?

Like I said in one response, it would be good to consider if we need an
polarization_change_in_progress state that refuses requests.
I'm guessing not, if a request is always completed before the next is handl=
ed
and there is no way to lose requests.
I don't know how long it would take to change the CPU assignment and if the=
re
is a chance that could be overwhelmed by too many requests.
Probably not but something worth thinking about.

Might be a good idea to add a test case that performs test via qmp.
So starts an instance with some cpu topology assignments, checks that
qmp returns the correct topology, hot plugs a cpu and does another check,
Changes topology attributes, etc.
I guess this would be an avocado test.
